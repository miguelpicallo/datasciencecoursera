library(shiny)

shinyUI(
  pageWithSidebar(
    # Application title
    headerPanel("Computing body mass index"),
    sidebarPanel(
      numericInput('h', 'principal height measure: cm or feet', 180, min = 1, max = 250, step = 1),
      numericInput('h2', 'secondary height measure: inches', 1, min = 1, max = 250, step = 1),
      numericInput('w', 'weight', 70, min = 1, max = 250, step = 1),
      selectInput('uh','Unit of height',
                  list('centimeters'='cm',
                       'feet/inches'='ftin')),
      selectInput('uw','Unit of weight',
                  list('kilograms'='kg',
                       'pounds'='lb')),
      
      submitButton('Submit')
    ),
    mainPanel(
      h3('Results'),
      h4('body mass index in kg/m^2:'),
      verbatimTextOutput("bmi"),
      h4('category:'),
      verbatimTextOutput("state")
    )
  )
)


