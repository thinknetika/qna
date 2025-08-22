server "qna-stud.ru", user: "deployer", roles: %w{app db web}, primary: true
set :rail_env, :production

set :ssh_options, {
  keys: %w(/home/elbub/.ssh/personal_key),
  forward_agent: true,
  auth_methods: %w(publickey password),
  port: 2222
}