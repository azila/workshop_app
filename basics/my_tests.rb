require 'minitest/autorun'
require './example'
require 'fileutils'

class ArticleTest < Minitest::Test
  def setup
    @article = Article.new("My Title", "Something", "My author")
  end

  def test_initialization
    assert_equal "My Title", @article.title, 'Title should be initialized.'
    assert_equal "Something", @article.body, 'Body should be initialized.' 
    assert_equal "My author", @article.author, 'Author should be initialized.' 
    assert_equal 0, @article.likes, 'Likes should equal 0.'
    assert_equal 0, @article.dislikes, 'Dislikes should equal 0.'
    assert_in_delta Time.now, @article.created_at, 500, 'Wrong creation time'
  end

  def test_initialization_with_anonymous_author
    assert_equal nil, Article.new("Some Title", "Some body").author
  end

  def test_liking
    5.times { @article.like! }
    assert_equal 5, @article.likes, 'Number of likes should increase.'
  end

  def test_disliking
    3.times { @article.dislike! }
    assert_equal 3, @article.dislikes, 'Number of dislikes should increase.'
  end

  def test_points
    @article.likes = 5
    @article.dislikes = 3
    assert_equal 2, @article.points, 'Wrong number of points.'
  end

  def test_long_lines
    line1 = "aa*aa" * 20
    line2 = "bb*bb" * 17
    line3 = "cc*cc" * 4
    lines = [line1, line2, line3]
    my_art = Article.new("Some Title", lines.join("\n"), "Some author")
    long_lines = [("aa*aa" * 20 + "\n"), ("bb*bb" * 17 + "\n")]

    assert_equal 2, my_art.long_lines.length, 'Wrong number of lines was selected.'    
    assert_equal long_lines, my_art.long_lines, 'Wrong lines selected by the method.'
  end

  def test_truncate
    assert_equal "S...", @article.truncate(4), 'Truncation did not happen properly.'
  end

  def test_truncate_when_limit_is_longer_then_body
    assert_equal "Something", @article.truncate(15), 'Should not truncate if limit is longer than body.'
  end

  def test_truncate_when_limit_is_same_as_body_length
    assert_equal "Something", @article.truncate(9), 'Should not truncate if limit is same as body.'
  end

  def test_length
    assert_equal @article.body.length, @article.length, 'Wrong body length.'
  end

  def test_votes
    @article.likes = 5
    @article.dislikes = 3
    assert_equal 8, @article.votes, 'Wrong number of votes'
  end

  def test_contain
    assert @article.contain?("Something"), "Body should contain string \"Something\""
    assert @article.contain?(/^So/), "Body should begin with string \"So\""
  end
end

class ArticlesFileSystemTest < Minitest::Test
  def setup
    @dir = Dir.mktmpdir
    @system = ArticlesFileSystem.new(@dir)
    art1 = Article.new("Title One", "Body One", "Author One")
    art2 = Article.new("Title Two", "Body Two", "Author Two")
    art3 = Article.new("Title Three", "Body Three", "Author Three")
    @to_save = [art1, art2, art3]
  end
  
  def test_saving
    @system.save(@to_save)
    file_one = File.read(@dir + "/title_one.article")
    file_two = File.read(@dir + "/title_two.article")

    assert_equal "Author One||0||0||Body One", file_one, 'Wrong data in saved file.'
    assert_equal "Author Two||0||0||Body Two", file_two, 'Wrong data in saved file.'
    
  end

  def test_loading

    File.write(@dir + "/" + "title_one" + ".article", "Author One||4||8||Body One")
    File.write(@dir + "/" + "title_two" + ".article", "Author Two||5||9||Body Two")
    File.write(@dir + "/" + "title_two" + ".other", "Author Other||5||8||Body Other")

    loaded_data = @system.load
    assert_equal 2, loaded_data.length, 'Wrong number of files.'

    loaded_data.sort!{ |a,b| a.author <=> b.author }
    assert_equal 4, loaded_data[0].likes, 'Wrong number of likes of the first author.'
    assert_equal "Author One", loaded_data[0].author, 'Wrong number of likes of the first author.'
  end
end

class WebPageTest < Minitest::Test

  def setup
    @dir = Dir.mktmpdir
    @page = WebPage.new(@dir)

    art1 = Article.new("Title One", "Body One two three four five six", "Author One")
    art2 = Article.new("Title Two", "Body Two", "Author One")
    art3 = Article.new("Title Three", "Body Three", "Author Three")
    art4 = Article.new("Title Four", "Body Four", "Author Four")
    art1.likes, art1.dislikes = 4, 8
    art2.likes, art2.dislikes = 5, 9
    art3.likes, art3.dislikes =14, 2
    art4.likes, art4.dislikes =15, 8

    @page.articles << art1
    @page.articles << art2
    @page.articles << art3
    @page.articles << art4

  end

  def test_new_without_anything_to_load
    assert_equal 0, WebPage.new(@dir).articles.length
  end

  def test_new_article
    expected_size = @page.articles.length + 1
    @page.new_article("Test title", "Test body", "Test author")
    assert_equal expected_size, @page.articles.length, 'Article was not added to array of articles.'
  end

  def test_longest_article
    assert_equal ["Title One", "Title Three", "Title Four", "Title Two"], @page.longest_articles.map(&:title), 'Longest article was not detected.'
  end

  def test_best_articles
    assert_equal ["Title Three", "Title Four", "Title Two", "Title One"], @page.best_articles.map(&:title)
  end

  def test_best_article
    assert_equal "Author Three", @page.best_article.author, 'Best article was not detected.'
  end

  def test_best_article_exception_when_no_articles_can_be_found
    assert_raises WebPage::NoArticlesFound do WebPage.new(@dir).best_article end
  end

  def test_worst_articles
    assert_equal ["Title One", "Title Two", "Title Four", "Title Three"], @page.worst_articles.map(&:title)
  end

  def test_worst_article
    assert_equal "Title One", @page.worst_article.title, 'This is not the worst article.'
  end

  def test_worst_article_exception_when_no_articles_can_be_found
    assert_raises WebPage::NoArticlesFound do WebPage.new(@dir).worst_article end
  end

  def test_most_controversial_articles
    assert_equal ["Title Four", "Title Three", "Title Two", "Title One"], @page.most_controversial_articles.map(&:title)
  end

  def test_votes
    assert_equal 65, @page.votes, 'Wrong number of votes.'
  end

  def test_authors
    assert_equal 4, @page.authors.length, 'Wrong number of authors.'
    assert_equal ["Author One", "Author Three", "Author Four"], @page.authors
  end

  def test_authors_statistics
    assert_equal 3, @page.authors_statistics.length, 'Wrong number of authors.'
    assert_equal ["Author One", "Author Three", "Author Four"], @page.authors_statistics.keys
  end

  def test_best_author
    assert_equal "Author One", @page.best_author, 'Wrong best author.'
  end

  def test_search
    assert_equal "Title One", @page.search("six").first.title, 'Wrong search result.'
    assert_equal "Title Four", @page.search(/^Body/).last.title, 'Wrong search result.'
  end
end

