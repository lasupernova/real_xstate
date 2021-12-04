# imports
from dash import Dash, dcc, html, Input, Output, State
from dash.exceptions import PreventUpdate
import dash_bootstrap_components as dbc
import mortgage_calc
import cashflow_calc


# app initiation
external_stylesheets = [dbc.themes.SOLAR]
app = Dash(__name__, external_stylesheets=external_stylesheets)

# layout
INPUT_WIDTH = 4
app.layout = html.Div([
                dbc.Row([
                    # MORTGAGE
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
                        html.Button('Submit', id='submit-val', style={"margin-top":"1%"}),
                        html.Hr(),
                        dbc.Row(id='monthly_payment',
                                children='Enter desired values and press submit',
                                style={"height":"20vh"}),
                        dbc.Row(
                                [
                                dcc.Checklist(
                                    options=[
                                        {'label': 'Show amortization', 'value': 'show'}
                                    ],
                                    id="amortization_checkbox",
                                    value=[],
                                    style={"display":"none"}
                                ),
                                dcc.Graph(id='viz_loan_balance',
                                    style={'margin': "10px", "visibility":"hidden"}
                                    )
                                ], style={"margin": "15px", "height":"40vh", "justify":"center", "align":"center"})
                            ], width=4, style={"margin": "15px"}),
                    # EXPENSES
                    dbc.Col([
                        dbc.Row([
                            dbc.Col([
                                dbc.Row([
                                    dbc.Col([dcc.Input(id='garbage', type='number', placeholder="Garbage Costs", min=0, max=1000, step=0.01)], 
                                            width=INPUT_WIDTH+4),
                                    dbc.Col([html.Label(id='garbage_text', children=["$"], title="Garbage Costs")],
                                    width=1)
                                ]),
                                dbc.Row([
                                    dbc.Col([dcc.Input(id='water', type='number', placeholder="Water Costs", min=0, max=1000, step=0.01)], 
                                            width=INPUT_WIDTH+4),
                                    dbc.Col([html.Label(id='water_text', children=["$"], title="Water Costs")],
                                    width=1)
                                ]),
                                dbc.Row([
                                    dbc.Col([dcc.Input(id='lawn_care', type='number', placeholder="Lawn Care", min=0, max=1000, step=0.01)], 
                                            width=INPUT_WIDTH+4),
                                    dbc.Col([html.Label(id='lawn_care_text', children=["$"], title="Lawn Care")],
                                    width=1)
                                ]),
                                dbc.Row([
                                    dbc.Col([dcc.Input(id='sewage', type='number', placeholder="Sewage", min=0, max=1000, step=0.01)], 
                                            width=INPUT_WIDTH+4),
                                    dbc.Col([html.Label(id='sewage_text', children=["$"], title="Sewage")],
                                    width=1)
                                ])
                            ], width=2),
                            dbc.Col([
                                dbc.Row([
                                    dbc.Col([dcc.Input(id='rental1', type='number', placeholder="Rental Income", min=0, max=2000, step=0.1)], 
                                            width=INPUT_WIDTH+4),
                                    dbc.Col([html.Label(id='rental1_text', children=["$"], title="Rental Income From Unit 1")],
                                    width=2)
                                ]),
                                dbc.Row([
                                    dbc.Col([dcc.Input(id='rental2', type='number', placeholder="Rental Income", min=0, max=2000, step=0.1)], 
                                            width=INPUT_WIDTH+4),
                                    dbc.Col([html.Label(id='rental2_text', children=["$"], title="Rental Income From Unit 12")],
                                    width=2)
                                ]),
                                dbc.Row([
                                        dbc.Col([dcc.Input(id='taxes', type='number', placeholder="Taxes", min=0, max=10000, step=0.01)], 
                                                width=INPUT_WIDTH+4),
                                        dbc.Col([html.Label(id='taxes_text', children=["$"], title="Taxes")],
                                        width=1)
                                    ]),
                                dbc.Row([
                                        dbc.Col([dcc.Input(id='insurance', type='number', placeholder="Insurance", min=0, max=1000, step=0.01)], 
                                                width=INPUT_WIDTH+4),
                                        dbc.Col([html.Label(id='insurance_text', children=["$"], title="Insurance")],
                                        width=1)
                                    ]),
                            ], width=2),
                            dbc.Col([
                                dbc.Row([
                                    dbc.Col([dcc.Input(id='legal', type='number', placeholder="Legal Fees", min=0, max=5000, step=0.1)], 
                                            width=INPUT_WIDTH+4),
                                    dbc.Col([html.Label(id='legal_text', children=["$"], title="Legal Fees (contributing to 'Total Investment')")],
                                    width=2)
                                ]),
                                dbc.Row([
                                    dbc.Col([dcc.Input(id='home_insp', type='number', placeholder="Home Inspection Fees", min=0, max=5000, step=0.1)], 
                                            width=INPUT_WIDTH+4),
                                    dbc.Col([html.Label(id='home_insp_text', children=["$"], title="Home Inspection Fees (contributing to 'Total Investment')")],
                                    width=2)
                                ]),
                                dbc.Row([
                                        dbc.Col([dcc.Input(id='bank', type='number', placeholder="Bank Fees", min=0, max=20000, step=0.01)], 
                                                width=INPUT_WIDTH+4),
                                        dbc.Col([html.Label(id='bank_text', children=["$"], title="Bank Fees (contributing to 'Total Investment')")],
                                        width=1)
                                    ])
                                    ], width=2)
                        ], justify="start"),
                        dbc.Row([
                            html.Button('Get Cashflow!', id='submit_expenses', 
                                        style={"horizontalAlign":"right", "width":"20%","margin-left":"10%","margin-bottom":"2%","margin-top":"1%"}),
                            html.Hr(),
                            dbc.Row(id='expenses_prompt',
                                            children='Enter desired values and press button'),
                            html.Button('Fill default values!', id='fill_default_vals', style={"background-color":"inherit", "border":"none", 
                                                                                               "color":"white", "text-align":"right",
                                                                                               'hover': { 'color': '#ff1a66'}})
                        ], justify="right")
                    ], style={"margin": "15px"})
                ]) #, style={"overflow":"hidden", "height":"60vh"}
], style={"overflow":"hidden", "height":"100vh"}) #


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
                dbc.Row([html.Label(id='monthly_pay_label', children=[f'Mthly. Payment'])], style={'height': '5vh'}),
                dbc.Row([html.Label(id='monthly_pay_result', children=[f'${result:.2f}'])], style={'height': '10vh'})
                ], width=info_col_width),
             dbc.Col([
                dbc.Row([html.Label(id='downpayment_label', children=[f'Downpayment'])], style={'height': '5vh'}),
                dbc.Row([html.Label(id='downpayment_result', children=[f'${offer*(downpayment/100):.0f}'])], style={'height': '10vh'})
                ], width=info_col_width),
            dbc.Col([
                dbc.Row([html.Label(id='loan_label', children=[f'Loan'])], style={'height': '5vh'}),
                dbc.Row([html.Label(id='loan_result', children=[f'${loan:.0f}'])], style={'height': '10vh'})
                ], width=info_col_width)]

        ## mortgage viz
        loan_balance = mortgage_calc.loan_balance_overview(loan, interest_rate/12, mortgage_period, yoi=list(range(1, 31)))
        loan_balance_viz = figure={
                        'data': [
                            {'x': [k for k, v in loan_balance.items()], 'y': [v[1] for k, v in loan_balance.items()], 'name':"Paid"},
                            {'x': [k for k, v in loan_balance.items()], 'y': [v[0] for k, v in loan_balance.items()], 'name':"Outstanding"},
                                ],
                        'layout': dict(title='Amortization over Time', margin={'l':30, 'r':30, 't':30, 'b':30}) 
                        }

        #create Checkbox
        amortization_style = {"display":"block"}
        return info, amortization_style, loan_balance_viz


@app.callback(
    Output('viz_loan_balance', 'style'),
    Input('amortization_checkbox', 'value')
)
def show_amortization(check_value):
    print(check_value)
    if check_value:
        return {"margin":"15px"}
    else:
        return {"margin":"15px",'visibility':'hidden'}


@app.callback(
    [Output('garbage', 'value'),
    Output('water', 'value'),
    Output('lawn_care', 'value'),
    Output('sewage', 'value'),
    Output('rental1', 'value'),
    Output('rental2', 'value'),
    Output('taxes', 'value'),
    Output('insurance', 'value'),
    Output('legal', 'value'),
    Output('home_insp', 'value'),
    Output('bank', 'value'),
    Output('offer', 'value')],
    Input('fill_default_vals', 'n_clicks')
)
def fill_defaults(n_clicks):
    if n_clicks is None:
        raise PreventUpdate
    else:
        return 0, 400, 400, 400, 750, 850, 3260, 400, 700, 450, 9620, 100000


@app.callback(
    Output('expenses_prompt', 'children'),
    Input('submit_expenses', 'n_clicks'),
    [State('garbage', 'value'),
    State('water', 'value'),
    State('lawn_care', 'value'),
    State('sewage', 'value'),
    State('rental1', 'value'),
    State('rental2', 'value'),
    State('taxes', 'value'),
    State('insurance', 'value'),
    State('legal', 'value'),
    State('home_insp', 'value'),
    State('bank', 'value'),
    State('downpayment', 'value'),
    State('offer', 'value')]
)
def summarize_expenses(n_clicks, garbage, water, lawn_care, sewage, rental1, rental2, taxes, insurance,
                        legal, home_insp, bank, downpayment, offer):
    if n_clicks is None:
        raise PreventUpdate
    else:
        all_expenses = sum([garbage, water, lawn_care, sewage, taxes, insurance])
        rental_assoc_exp = cashflow_calc.rental_assoc_expenses([rental1, rental2])
        downpayment = offer*downpayment/100  # downpayment is inserted in percent of offer - but cashflow_calc function takes dollar amount
        test_all = cashflow_calc.cashflow_overview([rental1, rental2], 
                                                   [garbage, water, lawn_care, sewage, taxes, insurance],
                                                   downpayment, 
                                                   legal, home_insp, 0, bank,
                                                   offer)
        info_col_width = 3
        text_row_height = 3
        info_row_height = 6
        info=[dbc.Row(
                [
                    dbc.Col([
                        dbc.Row([html.Label(id='total_monthly_expenses', children=[f'Mthly. Expenses'])], style={'height': f'{text_row_height}vh'}),
                        dbc.Row([html.Label(id='total_monthly_expenses_result', children=[f'${all_expenses/12:.0f}'])], style={'height': f'{info_row_height}vh'})
                        ], width=info_col_width),
                    dbc.Col([
                        dbc.Row([html.Label(id='prop_mgmt', children=[f'Property Management Costs'])], style={'height': f'{text_row_height}vh'}),
                        dbc.Row([html.Label(id='prop_mgmt_result', children=[f'${rental_assoc_exp[0]:.0f}'])], style={'height': f'{info_row_height}vh', "font-size":"26"})
                        ], width=info_col_width),
                    dbc.Col([
                        dbc.Row([html.Label(id='vacancy_costs', children=[f'Vacancy Costs'])], style={'height': f'{text_row_height}vh'}),
                        dbc.Row([html.Label(id='vacancy_costs_result', children=[f'${rental_assoc_exp[1]:.0f}'])], style={'height': f'{info_row_height}vh', "font-size":"26"})
                        ], width=info_col_width),
                    dbc.Col([
                        dbc.Row([html.Label(id='capital_expenditure', children=[f'Capital Expenditure'])], style={'height': f'{text_row_height}vh'}),
                        dbc.Row([html.Label(id='capital_expenditure_result', children=[f'${rental_assoc_exp[2]:.0f}'])], style={'height': f'{info_row_height}vh', "font-size":"26"})
                        ], width=info_col_width)
                ]),
            dbc.Row(
                [
                    dbc.Col([
                        dbc.Row(["  "], style={'height': f'4vh'}),
                        dbc.Row(["Net Operating Income"]),
                        dbc.Row(["Net Operating Costs"]),
                        dbc.Row(["Total Monthly Expenses"]),
                        dbc.Row(["Cashflow"]),
                        dbc.Row(["Cash-o-Cash ROI"]),
                        dbc.Row(["Cap Rate"]),
                        dbc.Row(["ROI"]),
                        dbc.Row(["ROI Date"]),
                    ], width=2),
                    dbc.Col([
                        dbc.Row([html.Label(id='real', children=[f'REAL'])], justify="center", style={'height': f'4vh', 'text-align': 'center'}),
                        dbc.Row([
                            html.Label(children=[f"$ {test_all['real']['net_op_income_MO']:.2f} (MO.) / $ {test_all['real']['net_op_income_YR']:.2f} (YR.)"], style={'text-align': 'center'})
                            ]),
                        dbc.Row([
                            html.Label(children=[f"$ {test_all['real']['net_op_cost']:.2f}"], style={'text-align': 'center'})
                            ]),
                        dbc.Row([
                            html.Label(children=[f"$ {test_all['real']['total_monthly_exp']:.2f}"], style={'text-align': 'center'})
                            ]),
                        dbc.Row([
                            html.Label(children=[f"$ {test_all['real']['cashflow_MO']:.2f} (MO.) / {test_all['real']['cashflow_YR']:.2f} (YR.)"], style={'text-align': 'center'})
                            ]),
                        dbc.Row([
                            html.Label(children=[f"{test_all['real']['coc_ROI']:.2%}"], style={'text-align': 'center'})
                            ]),
                        dbc.Row([
                            html.Label(children=[f"{test_all['real']['CAP']:.2%}"], style={'text-align': 'center'})
                            ]),
                        dbc.Row([
                            html.Label(children=[f"{test_all['real']['ROI']:.2f} years"], style={'text-align': 'center'})
                            ]),
                        dbc.Row([
                            html.Label(children=[f"{test_all['real']['ROI_date']}"], style={'text-align': 'center'})
                            ])
                        ], width=4),
                    dbc.Col([
                        dbc.Row([html.Label(id='hypo', children=[f'HYPO'])], justify="center", style={'height': f'4vh', 'text-align': 'center'}),
                        dbc.Row([
                            html.Label(children=[f"$ {test_all['hypo']['net_op_income_MO']:.2f} (MO.) / $ {test_all['hypo']['net_op_income_YR']:.2f} (YR.)"], style={'text-align': 'center'})
                            ]),
                        dbc.Row([
                            html.Label(children=[f"$ {test_all['hypo']['net_op_cost']:.2f}"], style={'text-align': 'center'})
                            ]),
                        dbc.Row([
                            html.Label(children=[f"$ {test_all['hypo']['total_monthly_exp']:.2f}"], style={'text-align': 'center'})
                            ]),
                        dbc.Row([
                            html.Label(children=[f"$ {test_all['hypo']['cashflow_MO']:.2f} (MO.) / $ {test_all['hypo']['cashflow_YR']:.2f} (YR.)"], style={'text-align': 'center'})
                            ]),
                        dbc.Row([
                            html.Label(children=[f"{test_all['hypo']['coc_ROI']:.2%}"], style={'text-align': 'center'})
                            ]),
                        dbc.Row([
                            html.Label(children=[f"{test_all['hypo']['CAP']:.2%}"], style={'text-align': 'center'})
                            ]),
                        dbc.Row([
                            html.Label(children=[f"{test_all['hypo']['ROI']:.2f} years"], style={'text-align': 'center'})
                            ]),
                        dbc.Row([
                            html.Label(children=[f"{test_all['hypo']['ROI_date']}"], style={'text-align': 'center'})
                            ])
                        ], width=4)
                ], justify="around")
        ]
        return info

if __name__ == '__main__':
    print("Imports done!")
    app.run_server(debug=True)
