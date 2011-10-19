CONF=YAML::load(ERB.new(IO.read(File.join(Rails.root,'config','omniauth.yml'))).result)[Rails.env]

Rails.application.config.middleware.use OmniAuth::Builder do
  t=CONF["twitter"]
  provider :twitter, t["consumer_key"],t["consumer_secret"]
  f=CONF["facebook"]
  provider :facebook,f["app_id"], f["app_secret"]
end

