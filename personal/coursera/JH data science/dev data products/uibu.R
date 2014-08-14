library('shiny')

# shinyUI(pageWithSidebar(
#   headerPanel("Hello Shiny!"),
#   sidebarPanel(
#     textInput(inputId="text1", label = "Input Text1"),
#     textInput(inputId="text2", label = "Input Text2"),
#     actionButton("goButton", "Go!")
#   ),
#   mainPanel(
#     p('Output text1'),
#     textOutput('text1'),
#     p('Output text2'),
#     textOutput('text2'),
#     p('Output text3'),
#     textOutput('text3')
#   )
# ))

shinyUI(pageWithSidebar(
  headerPanel("Example plot"),
  sidebarPanel(
    sliderInput('mu', 'Guess at the mu',value = 70, min = 60, max = 80, step = 0.05,)
  ),
  mainPanel(
    plotOutput('newHist')
  )
))

# shinyUI(pageWithSidebar(
#   headerPanel("Example plot"),
#   sidebarPanel(
#     sliderInput('mu', 'Guess at the mean',value = 70, min = 62, max = 74, step = 0.05,)
#   ),
#   mainPanel(
#     plotOutput('newHist')
#   )
# ))