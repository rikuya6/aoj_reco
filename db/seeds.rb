table_name = %w(users)
table_name.each do |name|
  path = Rails.root.join('db/seeds', Rails.env, name + '.rb')
  if File.exist?(path)
    print "Creating #{name}..."
    require path
    puts 'end'
  end
end
