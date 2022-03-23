library(ggplot2)

library(gganimate)

randomvalues <- round(runif(100, 3, 7), 2)

lastvalue <- 5.74

myvalues <- c(randomvalues, lastvalue)

myformula <- paste("physical abuse <- physical punishment", 
                   myvalues,
                   "(OR)")

id <- seq(1:101)

mydata <- data.frame(id, myvalues, myformula)

p1 <- ggplot(data = mydata,
             aes(x = 50,
                 y = 50,
                 label = myformula)) +
  xlim(0, 100) +
  ylim(0, 100) +
  geom_text(size = 5, color = "green") +
  labs(title = "Multilevel Logistic Regression") +
  theme_void() +
  theme(aspect.ratio = .10,
        panel.background = element_rect(fill = "black")) +
  transition_manual(id, cumulative = FALSE) 

animate(p1, 
        fps = 10, 
        renderer = gifski_renderer(loop = FALSE),
        height = 200, # manually adjust height
        width = 400)
