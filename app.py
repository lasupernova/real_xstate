from dash import Dash, dcc, html, Input, Output, State
from dash.exceptions import PreventUpdate
import dash_bootstrap_components as dbc
import mortgage_calc


external_stylesheets = [dbc.themes.LUX]
app = Dash(__name__, external_stylesheets=external_stylesheets, assets_ignore='.*css.*', suppress_callback_exceptions=True)


app.layout = html.Div([
    dbc.Row([
            dbc.Col([
                html.Div(dcc.Input(id='mortgage_period', type='number', placeholder="Mortgage period", min=1, max=30, step=1, value=30)),
                html.Div(dcc.Input(id='interest_rate_yearly', type='number', placeholder="Interest rate", value=0.0375)),
                html.Div(dcc.Input(id='downpayment', type='number', placeholder="Downpayment [%]", min=0, max=100, step=1, value=25)),
                html.Div(dcc.Input(id='offer', type='number', placeholder="Offer amount")),
                html.Button('Submit', id='submit-val'),
                html.Div(id='monthly_payment',
                        children='Enter desired values and press submit')
                ], style={"margin": "15px", 'width': '30vh', 'height': '90vh'}),
        dbc.Col(
            [
            dcc.Loading(id="loading-1",
                        type="default",
                        children=[
                            html.Div(id='viz_loan_balance',
                                children=[])
                        ])
            ], style={"margin": "15px", 'width': '65vh', 'height': '90vh', "justify":"center", "align":"center"})
        ], justify="center", align="center", className="h-50")
    ])


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
        # monthly payment
        loan = (1-downpayment/100)*offer
        result = mortgage_calc.mortgage_calc(loan, interest_rate/12, mortgage_period)
        # viz
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
                    style={'display':'inline-block', 'width': '90vh', 'height': '90vh'}
                )
        return f'Monthly payments will be: ${result:.2f}', loan_balance_viz


if __name__ == '__main__':
    print("Imports done!")
    app.run_server(debug=True)
