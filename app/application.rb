require 'pry'
class Application
  @@cart = []
  @@items = ["Apples","Carrots","Pears"]
  @@cart << @@items 

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)
    # Create a new route called /add that takes in a GET param with the key item. 
    # This should check to see if that item is in @@items and then add it to the cart if it is. 
    # Otherwise give an error
    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      if @@cart.empty?
        resp.write "Your cart is empty"
      else 
        resp.write @@cart.each{|item| resp.write "#{item}\n"}
      end 
    elsif req.path.match(/add/)
      item = req.params["item"]
      if @@items.include? item
        @@cart << item 
        resp.write("added #{item}")
      else 
        resp.write "We don't have that item"
      end 
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end

end
