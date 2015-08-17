source 'https://api.berkshelf.com'


# helper methods to keep the noise down
def local_cookbook(name, path=nil)
  if path
    cookbook name, path: "#{path}/#{name}"
  else
    cookbook name, path: "#{ENV['CHEF_REPO']}/cookbooks/#{name}"
  end
end

def git_application_cookbook(name, repo: nil)
  cookbook name,
           git: "git@github.com:fastly/#{repo || name}"
end

cookbook "yum", "< 3.0.0"
cookbook "golang", "~> 1.4.0"
cookbook "apt"
cookbook "omnibus"
local_cookbook "s3"

local_cookbook "build", ENV['FASTLY_REPO_ROOT']
