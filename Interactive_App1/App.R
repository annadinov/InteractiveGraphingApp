# Create an interactive graph that plots all of the cell types on one graph
# user can choose y-axis data (this specific graph is data for Mfrp)

library(shiny)
library(plotly)
library(shinycssloaders)

# load the Mfrp data
m_df <- readRDS("data/mfrp_data.rds")

# array of possible options for y-axis (26 possible options)
y <- c("OPC_inc", "OPC_dec", "OLG_inc", "OLG_dec", "OEG_inc", "OEG_dec",
       "ASC_inc", "ASC_dec", "NRP_dec", "ImmN_dec", "mNEUR_dec", "NendC_inc",
       "NendC_dec", "EPC_inc", "EPC_dec", "EC_inc", "EC_dec", "PC_inc", "PC_dec",
       "VSMC_inc", "ABC_inc", "ABC_dec", "MG_inc", "MG_dec", "MAC_inc", "MAC_dec")



# convert the chr variables (annotations and conditions) to ordinal factors for plotting
m_df1 <- m_df 
m_df1$annotations <- factor(m_df1$annotations, order = TRUE, 
                            levels = unique(m_df$annotations))
m_df1$conditions <- factor(m_df1$conditions, order = TRUE, 
                           levels = unique(m_df$conditions))

# define function for multiple line breaks
lineBreaks <- function(n){HTML(strrep(br(), n))}

# define ui ---
ui <- fluidPage(
  
  titlePanel("Interactive Mfrp Graphing"),
  
  sidebarLayout (
    sidebarPanel(
      selectInput("y_var", label = h3("Choose a variable for the y-axis:"), 
                  choices = y, selected = 1)
    ),
    
    mainPanel(
      withSpinner(plotlyOutput("graph"), type = 4)
    )
  )
)

# define server logic ---
server <- function(input, output) {
  output$graph <- renderPlotly({
    y_chosen <- input$y_var
    plot_ly(data = m_df1, x = ~annotations, y = m_df1[[y_chosen]], 
            color = ~conditions, type = "box") %>% layout(boxmode = "group")
  })
}

# run the app ---
shinyApp(ui = ui, server = server)