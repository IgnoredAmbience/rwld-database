workflow "Deploy" {
  on = "push"
  resolves = "Push"
}

action "Login" {
  uses = "actions/heroku@master"
  args = "container:login"
  secrets = ["HEROKU_API_KEY"]
}

action "Push" {
  uses = "actions/heroku@master"
  needs = "Login"
  args = "container:push web"
  secrets = ["HEROKU_API_KEY"]
  env = {
    HEROKU_APP = "rwld-database"
  }
}

action "release" {
  uses = "actions/heroku@master"
  needs = "push"
  args = "container:release web"
  secrets = ["HEROKU_API_KEY"]
}
