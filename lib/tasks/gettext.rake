namespace :gettext do
  def files_to_translate
    files = Dir.glob("{app,lib,config,locale}/**/*.{rb,erb,haml,rhtml}")
    files += Dir.glob("{themes}/**/*.{rb,erb,haml,rhtml}")
    return files
  end
end