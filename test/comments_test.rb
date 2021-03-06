require_relative 'test_helper'

describe WPDB::Comment do
  before do
    @comment = WPDB::Comment.create(
      :comment_author => 'Testy Testerson',
      :comment_author_email => 'testy@example.com',
      :comment_content => 'Test'
    )
  end

  it "creates a new comment" do
    assert @comment.comment_ID
  end

  it "attaches comments to posts" do
    post = WPDB::Post.create(:post_title => 'test', :post_author => 1)
    assert post.ID

    post.add_comment(@comment)
    assert @comment.post
    assert post.comments.length
    assert_equal post.comments.first.comment_post_ID, post.ID

    post.destroy
  end

  it "adds commentmeta" do
    @comment.add_commentmeta(:meta_key => 'test', :meta_value => 'test')

    comment = WPDB::Comment.where(:comment_ID => @comment.comment_ID).first
    assert comment.commentmeta.length > 0
    assert_equal 'test', comment.commentmeta.first.meta_key
    assert_equal 'test', comment.commentmeta.first.meta_value
  end

  after do
    @comment.destroy
  end
end
