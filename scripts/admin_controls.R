library(state)
library(redpul)

# library(mongolite)

dotenv::load_dot_env()
redisConnect(host = Sys.getenv("REDIS_HOST"))
state <- redisGet("fdrennan")



ggplot(response_to_robj("incoming_users", drop_data = T)) +
  aes(x = systime, y = n) +
  geom_col() +
  theme_solarized(light = FALSE) +
  ggtitle("Incoming to Servers")
