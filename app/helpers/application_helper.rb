module ApplicationHelper

  # Added by Jonathan on 10/6/11 to return a title
  # for each page
  def title
    base_title = "aabb"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
