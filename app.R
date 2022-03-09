library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(ggplot2)
library(plotly)
library(dplyr)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)
data <- read.csv("data/athlete_events_2000.csv")

app$layout(
  dbcContainer(
    list(
      dccGraph(id='plot-area'),
      dccDropdown(
          id='col-select',
          options = list(
            list(label = 'Male', value = 'Male'),
            list(label = 'Female', value = 'Female')
          ),
          value='Male')
      )
  )
)
app$callback(
    output('plot-area', 'figure'),
    list(input('col-select', 'value')),
    function(xcol) {
        filtered_df <- data %>% filter(Sex == xcol)
        p <- ggplot(filtered_df) +
            aes(x = Age) +
            geom_histogram(fill = 'lightblue', color = 'black') +
            ggthemes::scale_color_tableau() +
            labs(x = "Age", y = "Number of medals received",
                 title = "Age of athletes by the number of medals they received from 2000-2016")
        ggplotly(p)
    }
)



app$run_server(host = '0.0.0.0')
