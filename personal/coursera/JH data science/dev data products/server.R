library(shiny)

bmiComp <- function(h,h2,w,uh,uw) {
  if (uh!='cm'){
    h=h*30.46+h2*2.54
  }
  if (uw!='kg'){
    w=0.45359237*w
  }
  bmi=w/(h/100)^2
  bmi
}
stateComp <- function(bmi){
  state="not defined"
  if (bmi<18.5){
    state='underweight'
  }else if(bmi<25 & bmi>=18.5){
    state='normal'
  }else if(bmi<30 & bmi >=25){
    state='overweight'
  }else{
    state='obese'
  }
  state
}
shinyServer(
  function(input, output) {
    bmi=reactive(bmiComp(
      input$h,input$h2,input$w,input$uh,input$uw))
    output$bmi <- renderPrint({bmi()})
    output$state <- renderPrint({stateComp(bmi())})
  }
)

##################################

# Documentation:
  
# This app computes the body mass index (BMI) for a given person. Given the values for height and weight, 
# it determines the BMI and concludes in what category is that person. Height can either be given in 
# centimeters or feet/inches units, and weight in kilograms or pounds.

