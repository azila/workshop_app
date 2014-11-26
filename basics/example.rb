require 'pathname'

class Article
  attr_accessor :likes, :dislikes
  attr_reader :title, :body, :author, :created_at

  def initialize(title, body, author=nil)
    @title, @body, @author = title, body, author
    @created_at = Time.now
    @likes = @dislikes = 0
  end

  def like!
    self.likes +=1
  end

  def dislike!
    self.dislikes +=1
  end

  def points
    @likes - @dislikes
  end

  def votes
    @likes + @dislikes
  end
  
  def long_lines
    body.lines.select { |line | line.length > 80 }
  end

  def length
    body.length
  end	

  def truncate(limit)
    if (@body.length > limit) 
     (body.slice(0, limit-3) + "...")
    else
     @body 
    end
  end

  def contain?(pattern)
    !!body.match(pattern)
  end

end


class ArticlesFileSystem

  attr_reader :directory

  def initialize(directory)
    @directory = directory
  end

  def save(articles)

    articles.each do |article|
      File.open(self.directory + "/" + article.title.downcase.tr(" ", "_") + ".article", "w+") do |aFile|
        aFile.write(article.author + "||" + article.likes.to_s + "||" + article.dislikes.to_s + "||" + article.body)
      end
    end
  end

  def load

    Dir["#{@directory}/*.article"].map do |name|

      file = Pathname.new(name)
      file_data = file.read
      author, likes, dislikes, body = file_data.split('||')

      good_name = File.basename(file).gsub('.article', '').capitalize.gsub('_', ' ')   
      article = Article.new(good_name, body, author)
      article.likes, article.dislikes = likes.to_i, dislikes.to_i      
      article
    end

  end 

end


class WebPage

  class NoArticlesFound < StandardError; end

  attr_reader :articles

  def initialize(directory="/")    
    @helper = ArticlesFileSystem.new(directory)
    @articles = []
    load
  end

  def load
    @articles = @helper.load
  end

  def save
    @helper.save(@articles)
  end

  def new_article(title, body, author)
    article = Article.new(title, body, author)
    @articles << article
  end

  def longest_articles
    articles.sort_by(&:length).reverse
  end

  def best_articles
    articles.sort_by(&:points).reverse
  end

  def worst_articles
    best_articles.reverse
  end

  def best_article
    raise WebPage::NoArticlesFound if @articles.empty?
    best_articles.first
  end

  def worst_article
    raise WebPage::NoArticlesFound if @articles.empty?
    worst_articles.first
  end

  def most_controversial_articles
    articles.sort_by(&:votes).reverse
  end

  def votes
    articles.map(&:votes).inject(0, &:+)
  end 

  def authors
    @articles.map(&:author).uniq
  end

  def authors_statistics
    anthor_article = Hash.new(0)
    articles.each{ |article| anthor_article[article.author]+=1 }
    anthor_article
  end

  def best_author
    authors_statistics.max_by {|author, count| count}[0]
  end

  def search(query)
    articles.select { |article | !!article.body.match(query) }
  end
  
end
