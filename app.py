# imports
from dash import Dash, dcc, html, Input, Output, State
from dash.exceptions import PreventUpdate
import dash_bootstrap_components as dbc
import mortgage_calc


# app initiation
external_stylesheets = [dbc.themes.SOLAR]
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
                        dbc.Row([
                            dbc.Col([dcc.Input(id='offer', type='number', placeholder="Offer Amount")], 
                                    width=INPUT_WIDTH),
                            dbc.Col([html.Label(id='offer_text', children=["$"], title="Offer Amount")],
                            width=3)
                        ]),
                        html.Button('Submit', id='submit-val'),
                        html.Hr(),
                        dbc.Row(id='monthly_payment',
                                children='Enter desired values and press submit'),
                        dbc.Row(
                                [
                                dcc.Loading(id="loading-1",
                                            type="default",
                                            children=[
                                                dcc.Checklist(
                                                    options=[
                                                        {'label': 'Show amortization', 'value': 'show_loan_balance'}
                                                    ],
                                                    id="amortization_checkbox",
                                                    value=[],
                                                    style={"display":"none"}
                                                ),
                                                dcc.Graph(id='viz_loan_balance',
                                                    style={'margin': "10px", "display":"none"}
                                                    )
                                                ])
                                ], style={"margin": "15px", "height":"40vh", "justify":"center", "align":"center"})
                            ], width=4, style={"margin": "15px"}),
                    dbc.Col([
                        dbc.Row([
                            dbc.Col([dcc.Input(id='mortgage_period2', type='number', placeholder="Mortgage period", min=1, max=30, step=1, value=30)], 
                                    width=INPUT_WIDTH),
                            dbc.Col([html.Label(id='mortgage_period_text2', children=["years"], title="Mortgage period")],
                            width=3)
                        ]),
                        dbc.Row([
                            dbc.Col([dcc.Input(id='interest_rate_yearly2', type='number', placeholder="Interest rate", min=0, max=100, step=0.005, value=3.375)], 
                                    width=INPUT_WIDTH),
                            dbc.Col([html.Label(id='interest_rate_text2', children=["%"], title="Yearly Interest Rate")],
                            width=3)
                        ]),
                        dbc.Row([
                            dbc.Col([dcc.Input(id='downpayment2', type='number', placeholder="Downpayment [%]", min=0, max=100, step=1, value=25)], 
                                    width=INPUT_WIDTH),
                            dbc.Col([html.Label(id='downpayment_text2', children=["%"], title="Downpayment")],
                            width=3),
                        ]),
                        dbc.Row([
                            dbc.Col([dcc.Input(id='offer2', type='number', placeholder="Offer Amount")], 
                                    width=INPUT_WIDTH),
                            dbc.Col([html.Label(id='offer_text2', children=["$"], title="Offer Amount")],
                            width=3)
                        ]),
                        html.Button('Submit', id='submit-val2'),
                        html.Hr(),
                        dbc.Row(id='monthly_payment2',
                                        children='Enter desired values and press submit')
                            ], style={"margin": "15px"})
                ], style={"overflow":"hidden", "height":"60vh"})
], style={"overflow":"hidden", "height":"100vh"})


# callbacks
@app.callback(
    [Output('monthly_payment', 'children'),
    Output('amortization_checkbox', 'style'),
    Output('viz_loan_balance', 'figure')],
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
        #info_texts
        info_col_width = 4
        info=[dbc.Col([
                dbc.Row([html.Label(id='monthly_pay_label', children=[f'Mthly. Payment'])], style={'height': '10vh'}),
                dbc.Row([html.Label(id='monthly_pay_result', children=[f'${result:.2f}'])], style={'height': '15vh'})
                ], width=info_col_width),
             dbc.Col([
                dbc.Row([html.Label(id='downpayment_label', children=[f'Downpayment'])], style={'height': '10vh'}),
                dbc.Row([html.Label(id='downpayment_result', children=[f'${offer*(downpayment/100):.0f}'])], style={'height': '15vh', "font-size":"26"})
                ], width=info_col_width),
            dbc.Col([
                dbc.Row([html.Label(id='loan_label', children=[f'Loan'])], style={'height': '10vh'}),
                dbc.Row([html.Label(id='loan_result', children=[f'${loan:.0f}'])], style={'height': '15vh', "font-size":"26"})
                ], width=info_col_width)]

        ## mortgage viz
        loan_balance = mortgage_calc.loan_balance_overview(loan, interest_rate/12, mortgage_period, yoi=list(range(1, 31)))
        loan_balance_viz = figure={
                        'data': [
                            {'x': [k for k, v in loan_balance.items()], 'y': [v[1] for k, v in loan_balance.items()], 'name':"Paid"},
                            {'x': [k for k, v in loan_balance.items()], 'y': [v[0] for k, v in loan_balance.items()], 'name':"Outstanding"},
                                ]
                        }

        #create Checkbox
        amortization_style = {"display":"inline-block"}
        return info, amortization_style, loan_balance_viz


@app.callback(
    Output('viz_loan_balance', 'style'),
    Input('amortization_checkbox', 'value')
)
def show_amortization(check_value):
    if check_value=="show_loan_balance":
        return {"margin":"15px",'display':'block'}
    else:
        return {"margin":"15px"}

if __name__ == '__main__':
    print("Imports done!")
    app.run_server(debug=True)
