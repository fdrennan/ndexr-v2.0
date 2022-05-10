# library(mongolite)
library(redpul)
dotenv::load_dot_env()



ggplot(data) +
  aes(x = redis_timestamp, y = n_obs) +
  geom_col() +
  facet_grid(user_name ~ ., scales = "free_y")
