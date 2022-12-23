def mkdir(path)
  if(!Dir.exist?(path))
    system("mkdir #{path}")
    return true
  else
    return false
  end
end