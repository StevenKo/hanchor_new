# encoding: utf-8
namespace :fix do
  task :image => :environment do
    ProductInfo.all.each do |p|
      matches = p.feature.scan(/<img.*\/>/)
      matches.each do |m|
        new_string = m.gsub(/(style=.*px\")/,"")
        p.feature.gsub!(m,new_string)
      end
      p.save
    end
    News.all.each do |n|
      matches = n.content.scan(/<img.*\/>/)
      matches.each do |m|
        new_string = m.gsub(/(style=.*px\")/,"")
        n.content.gsub!(m,new_string)
      end
      n.save
    end
  end
end



# ProductInfo.all.each do |p|
#   # matches = p.feature.scan(/<img.*\/>/)
#   matches = p.feature.scan(/<iframe.*\/iframe>/)
#   matches.each do |m|
#     new_string  = m.gsub("height=\"100%\"","height=\"350\"")
    
#     p.feature.gsub!(m,new_string)
#   end
#   p.save
# end


# ProductInfo.all.each do |p|

#   matches = p.feature.scan(/<iframe.*\/iframe>/)
#   puts matches[0]
#   puts p.id

# end