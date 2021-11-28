# imports
from dash import Dash, dcc, html, Input, Output, State
from dash.exceptions import PreventUpdate
import dash_bootstrap_components as dbc
import mortgage_calc


# app initiation
external_stylesheets = [dbc.themes.LITERA]
app = Dash(__name__, external_stylesheets=external_stylesheets)

# layout
INPUT_WIDTH = 4
app.layout = html.Div([
    dbc.Row([
            dbc.Col([
                dbc.Row([
                    dbc.Col([dcc.Input(id='mortgage_period', type='number', placeholder="Mortgage period", min=1, max=30, step=1, value=30)], 
                            width=INPUT_WIDTH),
                    dbc.Col([html.Label(id='mortgage_period_text', children=["years"], title="Mortgage period")],
                    width=3)
                ]),
                dbc.Row([
                    dbc.Col([dcc.Input(id='interest_rate_yearly', type='number', placeholder="Interest rate", min=0, max=100, step=0.005, value=3.375)], 
                            width=INPUT_WIDTH),
                    dbc.Col([html.Label(id='interest_rate_text', children=["%"], title="Yearly Interest Rate")],
                    width=3)
                ]),
                dbc.Row([
                    dbc.Col([dcc.Input(id='downpayment', type='number', placeholder="Downpayment [%]", min=0, max=100, step=1, value=25)], 
                            width=INPUT_WIDTH),
                    dbc.Col([html.Label(id='downpayment_text', children=["%"], title="Downpayment")],
                    width=3)
                ]),
                html.Div(dcc.Input(id='offer', type='number', placeholder="Offer amount")),
                html.Button('Submit', id='submit-val'),
                dbc.Row([html.Div(id='monthly_payment',
                                children='Enter desired values and press submit')
                        ], style={"margin": "15px", "justify":"center"})
                    ]),
        dbc.Col(
            [
            dcc.Loading(id="loading-1",
                        type="default",
                        children=[
                            html.Div(id='viz_loan_balance',
                                children=[])
                        ])
            ], width="auto", style={"margin": "15px", 'width': '65vh', 'height': '90vh', "justify":"center", "align":"center"})
        ], justify="center", align="center", className="h-50")
    ])


# callbacks
@app.callback(
    [Output('monthly_payment', 'children'),
    Output('viz_loan_balance', 'children')],
    Input('submit-val', 'n_clicks'),
    [State('mortgage_period', 'value'),
    State('interest_rate_yearly', 'value'),
    State('downpayment', 'value'),
    State('offer', 'value')]
)
def calculate_payment(n_clicks, mortgage_period, interest_rate, downpayment, offer):
    if n_clicks is None:
        raise PreventUpdate
    else:
        ## mortgage info
        # other info, unit adjustment
        loan = (1-downpayment/100)*offer
        interest_rate /= 100
        # monthly payment
        result = mortgage_calc.mortgage_calc(loan, interest_rate/12, mortgage_period)
        #total cost 
        total_cost = mortgage_calc.total_cost(loan, interest_rate/12, mortgage_period)
        #total interest paid
        total_interest = total_cost - loan
        info=[html.Div(id='monthly_pay_result', children=[f'{"Monthly payments will be:"} ${result:.2f}']),
              html.Div(id='total_cost', children=[f'{"Total costs of mortgage:"} ${total_cost:.0f}']),
              html.Div(id='total_interest', children=[f'Total interest paid: ${total_interest:.0f}'])]

        ## mortgage viz
        loan_balance = mortgage_calc.loan_balance_overview(loan, interest_rate/12, mortgage_period, yoi=list(range(1, 31)))
        loan_balance_viz = dcc.Graph(
                    id=f'loan_balance',
                    figure={
                        'data': [
                            {'x': [k for k, v in loan_balance.items()], 'y': [v[1] for k, v in loan_balance.items()], 'name':"Paid"},
                            {'x': [k for k, v in loan_balance.items()], 'y': [v[0] for k, v in loan_balance.items()], 'name':"Outstanding"},
                                ],
                        'layout': dict(title=['Placeholder', 'soinds'], margin={'l':20, 'r':20, 't':30, 'b':30}) 
                        },
                    style={'display':'inline-block', 'width': '90vh', 'height': '90vh', 'margin':'30px'}
                )
        return info, loan_balance_viz


if __name__ == '__main__':
    print("Imports done!")
    app.run_server(debug=True)
