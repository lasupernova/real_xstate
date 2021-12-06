# imports
from dash import Dash, dcc, html, Input, Output, State, ALL, MATCH
from dash.exceptions import PreventUpdate
import dash_bootstrap_components as dbc
import dash_daq as daq
import mortgage_calc
import cashflow_calc
import os


# app initiation
external_stylesheets = [dbc.themes.SOLAR, f"assets{os.sep}evaluation_page.css"]
app = Dash(__name__, external_stylesheets=external_stylesheets)
app.config['suppress_callback_exceptions'] = True  # suppress callbck exception created by "export_results()", as Output-ID does not exist in initial state

# layout
INPUT_WIDTH = 4
app.layout = html.Div([
                dbc.Row([
                    # MORTGAGE
                    dbc.Col([
                        dbc.Row([
                            dbc.Col([html.Label(id='mortgage_period_label', children=["Term"], style={"margin-right": "15px"})], 
                                    width=INPUT_WIDTH+1),
                            dbc.Col([dcc.Input(id='mortgage_period', type='number', placeholder="Mortgage period", min=1, max=30, step=1, value=30),
                                    html.Label(id='mortgage_period_text', children=["years"], title="Mortgage period", style={"margin-left":"25%", "padding-left":"5px"})],
                                    width=INPUT_WIDTH+3)
                        ]),
                        dbc.Row([
                            dbc.Col([html.Label(id='interest_rate_label', children=["Interest Rate"], style={"margin-right": "15px"})], 
                                    width=INPUT_WIDTH+1),
                            dbc.Col([dcc.Input(id='interest_rate_yearly', type='number', placeholder="Interest rate", min=0, max=100, step=0.005, value=3.375),
                                    html.Label(id='interest_rate_text', children=["%"], title="Yearly Interest Rate", style={"margin-left":"5%", "padding-left":"3px"})],
                                    width=INPUT_WIDTH+3)
                        ], justify="around"),
                        dbc.Row([
                            dbc.Col([html.Label(id='downpayment_label', children=["Downpayment"], style={"margin-right": "15px"})], 
                                    width=INPUT_WIDTH+1),
                            dbc.Col([dcc.Input(id='downpayment', type='number', placeholder="Downpayment [%]", min=0, max=100, step=1, value=25),
                                    html.Label(id='downpayment_text', children=["%"], title="Downpayment", style={"margin-left":"25%"})],
                                    width=INPUT_WIDTH+3)
                        ]),
                        dbc.Row([
                            dbc.Col([html.Label(id='offer_label', children=["Offer Amount"], style={"margin-right": "15px"})], 
                                    width=INPUT_WIDTH+1),
                            dbc.Col([dcc.Input(id='offer', type='number', placeholder="Offer Amount")],
                                    width=INPUT_WIDTH),
                            dbc.Col([html.Label(id='offer_text', children=["$"], title="Offer Amount", style={"padding-left":"15px"})],
                                    width=1)
                        ]),
                        html.Button('Submit', id='submit-val', style={"margin-top":"1%", "margin-bottom":"2%"}),
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
                            ], width=2, style={"margin": "15px"}),
                    # Spaceholder
                    dbc.Col([], width=1),
                    # EXPENSES
                    dbc.Col([
                        dbc.Row([
                            dbc.Col([
                                dbc.Row([
                                    dbc.Col([html.Label(id='garbage_label', children=["Garbage"], style={"margin-right": "15px"})], 
                                            width=INPUT_WIDTH),
                                    dbc.Col([dcc.Input(id={'type': 'input','group':'utilities', 'index': 'garbage'}, type='number', placeholder="yearly", min=0, max=1000, step=0.01, style={"text-align":"center"}),
                                            html.Button('$/Year', className="interval_switch", id={'type': 'switch','group':'utilities', 'index': 'garbage'}, title="Click to switch between year/month intervals",
                                                        value="year",
                                                        style={"text-align":"center", "width":"20%","margin-left":"5%", "padding-left":"3px",
                                                            "background-color":"inherit", "border":"None"})], 
                                            width=INPUT_WIDTH+4),
                                    # dbc.Col([html.Label(id='garbage_text', children=["$"], title="Garbage Costs")],
                                    #         width=1, align="left"),
                                ], justify="around"),
                                dbc.Row([
                                    dbc.Col([html.Label(id="water_label", children=["Water"])], 
                                            width=INPUT_WIDTH),
                                    dbc.Col([dcc.Input(id={'type': 'input','group':'utilities', 'index': 'water'}, type='number', placeholder="yearly", min=0, max=1000, step=0.01, style={"text-align":"center"}),
                                            html.Button('$/Year', className="interval_switch", id={'type': 'switch','group':'utilities', 'index': 'water'}, title="Click to switch between year/month intervals",
                                                        value="year",
                                                        style={"text-align":"center", "width":"20%","margin-left":"5%", "padding-left":"3px",
                                                            "background-color":"inherit", "border":"None"})], 
                                            width=INPUT_WIDTH+4),
                                    # dbc.Col([html.Label(id='water_text', children=["$"], title="Water Costs")],
                                    # width=3)
                                ], justify="around"),
                                dbc.Row([
                                    dbc.Col([html.Label(id='lawn_label', children=["Lawn Care"])], 
                                            width=INPUT_WIDTH),
                                    dbc.Col([dcc.Input(id={'type': 'input','group':'utilities', 'index': 'lawn_care'}, type='number', placeholder="yearly", min=0, max=1000, step=0.01, style={"text-align":"center"}),
                                            html.Button('$/Year', className="interval_switch", id={'type': 'switch','group':'utilities', 'index': 'lawn_care'}, title="Click to switch between year/month intervals",
                                                       value="year",
                                                       style={"text-align":"center", "width":"20%","margin-left":"5%", "padding-left":"3px",
                                                            "background-color":"inherit", "border":"None"})], 
                                            width=INPUT_WIDTH+4),
                                    # dbc.Col([html.Label(id='lawn_care_text', children=["$"], title="Lawn Care")],
                                    # width=3)
                                ], justify="around"),
                                dbc.Row([
                                    dbc.Col([html.Label(id='sewage_label', children=["Sewage"])], 
                                            width=INPUT_WIDTH),
                                    dbc.Col([dcc.Input(id={'type': 'input','group':'utilities', 'index': 'sewage'}, type='number', placeholder="yearly", min=0, max=1000, step=0.01, style={"text-align":"center"}),
                                            html.Button('$/Year', className="interval_switch", id={'type': 'switch','group':'utilities', 'index': 'sewage'}, title="Click to switch between year/month intervals",
                                                        value="year",
                                                        style={"text-align":"center", "width":"20%","margin-left":"5%", "padding-left":"3px",
                                                            "background-color":"inherit", "border":"None"})], 
                                            width=INPUT_WIDTH+4),
                                    # dbc.Col([html.Label(id='sewage_text', children=["$"], title="Sewage")],
                                    # width=3)
                                ], justify="around")
                            ], width=3),
                            dbc.Col([
                                dbc.Row([
                                    dbc.Col([html.Label(id='rental1_label', children=["Rent 1"])],   # TODO: combine two rent-switches into one
                                            width=INPUT_WIDTH),
                                    dbc.Col([dcc.Input(id={'type': 'input','group':'rents', 'index': 0}, type='number', placeholder="Rental Income", min=0, max=10000, step=0.1),
                                            html.Button('$/Month', className="interval_switch", id={'type': 'switch','group':'rents', 'index': 0}, title="Click to switch between year/month intervals",
                                                                value="month",
                                                                style={"text-align":"center", "width":"20%","margin-left":"8%", "padding-left":"3px",
                                                                    "background-color":"inherit", "border":"None"})], 
                                            width=INPUT_WIDTH+4),
                                ], justify="around"),
                                dbc.Row([
                                    dbc.Col([html.Label(id='rental2_label', children=["Rent 2"])], 
                                            width=INPUT_WIDTH),
                                    dbc.Col([dcc.Input(id={'type': 'input','group':'rents', 'index': 1}, type='number', placeholder="Rental Income", min=0, max=10000, step=0.1),
                                            html.Button('$/Month', className="interval_switch", id={'type': 'switch','group':'rents', 'index': 1}, title="Click to switch between year/month intervals",
                                                                value="month",
                                                                style={"text-align":"center", "width":"20%","margin-left":"8%", "padding-left":"3px",
                                                                    "background-color":"inherit", "border":"None"})], 
                                            width=INPUT_WIDTH+4)
                                ], justify="around"),
                                dbc.Row([
                                    dbc.Col([html.Label(id='taxes1_label', children=["Taxes"])], 
                                            width=INPUT_WIDTH),
                                    dbc.Col([dcc.Input(id={'type': 'input','group':'tax', 'index': 0}, type='number', placeholder="yearly", min=0, max=10000, step=0.01),
                                            html.Button('$/Year', className="interval_switch", id={'type': 'switch','group':'tax', 'index': 0}, title="Click to switch between year/month intervals",
                                                                value="year",
                                                                style={"text-align":"center", "width":"20%","margin-left":"5%", "padding-left":"3px",
                                                                    "background-color":"inherit", "border":"None"})], 
                                            width=INPUT_WIDTH+4),
                                ], justify="around"),
                                dbc.Row([
                                    dbc.Col([html.Label(id='insurance_label', children=["Insurance"])], 
                                            width=INPUT_WIDTH),
                                    dbc.Col([dcc.Input(id={'type': 'input','group':'insurance', 'index': 0}, type='number', placeholder="yearly", min=0, max=10000, step=0.01),
                                            html.Button('$/Year', className="interval_switch", id={'type': 'switch','group':'insurance', 'index': 0}, title="Click to switch between year/month intervals",
                                                                value="year",
                                                                style={"text-align":"center", "width":"20%","margin-left":"5%", "padding-left":"3px",
                                                                    "background-color":"inherit", "border":"None"})], 
                                            width=INPUT_WIDTH+4),
                                ], justify="around"),
                            ], width=3),
                            dbc.Col([
                                dbc.Row([
                                    dbc.Col([html.Label(id='legal_label', children=["Legal"])], 
                                            width=INPUT_WIDTH),
                                    dbc.Col([dcc.Input(id='legal', type='number', placeholder="Legal Fees", min=0, max=5000, step=0.1)], 
                                            width=INPUT_WIDTH+1),
                                    dbc.Col([html.Label(id='legal_text', children=["$"], title="Legal Fees (contributing to 'Total Investment')")],
                                    width=3)
                                ], justify="around"),
                                dbc.Row([
                                    dbc.Col([html.Label(id='home_insp_label', children=["Inspection"])], 
                                            width=INPUT_WIDTH),
                                    dbc.Col([dcc.Input(id='home_insp', type='number', placeholder="Home Inspection Fees", min=0, max=5000, step=0.1)], 
                                            width=INPUT_WIDTH+1),
                                    dbc.Col([html.Label(id='home_insp_text', children=["$"], title="Home Inspection Fees (contributing to 'Total Investment')")],
                                    width=3)
                                ], justify="around"),
                                dbc.Row([
                                    dbc.Col([html.Label(id='bank_label', children=["Bank"])], 
                                            width=INPUT_WIDTH),
                                        dbc.Col([dcc.Input(id='bank', type='number', placeholder="Bank Fees", min=0, max=20000, step=0.01)], 
                                                width=INPUT_WIDTH+1),
                                        dbc.Col([html.Label(id='bank_text', children=["$"], title="Bank Fees (contributing to 'Total Investment')")],
                                        width=3)
                                    ], justify="around")
                                ], width=3)
                        ], justify="evenly"),
                        dbc.Row([
                            html.Button('Get Cashflow!', id='submit_expenses', 
                                        style={"horizontalAlign":"right", "width":"20%","margin-left":"30%","margin-bottom":"2%","margin-top":"1%"}),
                            html.Hr(),
                            dbc.Row(id='expenses_prompt',
                                            children='Enter desired values and press button'),
                            html.Button('Fill default values!', id='fill_default_vals', style={"background-color":"inherit", "border":"none", 
                                                                                               "text-align":"right", "padding-top": "20px",
                                                                                               "margin-left":"80%","width":"15%"},
                                        className="undercover")
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
    [Output({'type': 'input','group':'utilities', 'index': 'garbage'}, 'value'),
    Output({'type': 'input','group':'utilities', 'index': 'water'}, 'value'),
    Output({'type': 'input','group':'utilities', 'index': 'lawn_care'}, 'value'),
    Output({'type': 'input','group':'utilities', 'index': 'sewage'}, 'value'),
    Output({'type': 'input','group':'rents', 'index': 0}, 'value'),
    Output({'type': 'input','group':'rents', 'index': 1}, 'value'),
    Output({'type': 'input','group':'tax', 'index': 0}, 'value'),
    Output({'type': 'input','group':'insurance', 'index': 0}, 'value'),
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
    Output('export_output', 'children'),
    Input('export_results_button', 'n_clicks'),
    [State({'type': 'input','group':'utilities', 'index': ALL}, 'value'),
    State({'type': 'switch','group':'utilities', 'index': ALL}, 'value'),
    State({'type': 'input','group':'rents', 'index': ALL}, 'value'),
    State({'type': 'switch','group':'rents', 'index': ALL}, 'value'),
    State({'type': 'input','group':'tax', 'index': 0}, 'value'),
    State({'type': 'switch','group':'tax', 'index': 0}, 'value'),
    State({'type': 'input','group':'insurance', 'index': 0}, 'value'),
    State({'type': 'switch','group':'insurance', 'index': 0}, 'value'),
    State('legal', 'value'),
    State('home_insp', 'value'),
    State('bank', 'value'),
    State('downpayment', 'value'),
    State('offer', 'value')]
)
def export_results(n_clicks, utilities, utilities_intervals, rents, rents_intervals, taxes, tax_interval, insurance, insurance_interval,
                        legal, home_insp, bank, downpayment, offer):
    if n_clicks is None:
        raise PreventUpdate
    else:
        downpayment = offer*downpayment/100

        # convert value to interval-value needed by cashflow_calc.cashflow_overview()  based on intervals passed  -- TODO: create function to avoid redundancy
        utilities = [val if interval=="year" else val*12 for val, interval in zip(utilities, utilities_intervals)]  # yearly costs for utilities used in cashflow-funcs per default
        rents = [val if interval=="month" else val/12 for val, interval in zip(rents, rents_intervals)]  # monthly costs for rents used in cashflow-funcs per default
        taxes = taxes if tax_interval=="year" else taxes*12
        insurance = insurance if insurance_interval=="year" else insurance*12

        export_path = cashflow_calc.cashflow_overview_print(rents, 
                                                   utilities + [taxes, insurance],
                                                   downpayment, 
                                                   legal, home_insp, 0, bank,
                                                   offer)

        return [
            f"""Analysis exported to:
            {export_path}"""
            ]


@app.callback(
    Output('expenses_prompt', 'children'),
    Input('submit_expenses', 'n_clicks'),
    [State({'type': 'input','group':'utilities', 'index': ALL}, 'value'),
    State({'type': 'switch','group':'utilities', 'index': ALL}, 'value'),
    State({'type': 'input','group':'rents', 'index': ALL}, 'value'),
    State({'type': 'switch','group':'rents', 'index': ALL}, 'value'),
    State({'type': 'input','group':'tax', 'index': 0}, 'value'),
    State({'type': 'switch','group':'tax', 'index': 0}, 'value'),
    State({'type': 'input','group':'insurance', 'index': 0}, 'value'),
    State({'type': 'switch','group':'insurance', 'index': 0}, 'value'),
    State('legal', 'value'),
    State('home_insp', 'value'),
    State('bank', 'value'),
    State('downpayment', 'value'),
    State('offer', 'value')]
)
def summarize_expenses(n_clicks, utilities, utilities_intervals, rents, rents_intervals, taxes, tax_interval, insurance, insurance_interval,
                        legal, home_insp, bank, downpayment, offer):
    if n_clicks is None:
        raise PreventUpdate
    else:
        # convert value to interval-value needed by cashflow_calc.cashflow_overview()  based on intervals passed
        utilities = [val if interval=="year" else val*12 for val, interval in zip(utilities, utilities_intervals)]  # yearly costs for utilities used in cashflow-funcs per default
        rents = [val if interval=="month" else val/12 for val, interval in zip(rents, rents_intervals)]  # monthly costs for rents used in cashflow-funcs per default
        taxes = taxes if tax_interval=="year" else taxes*12
        insurance = insurance if insurance_interval=="year" else insurance*12

        # calculate combined specs
        all_expenses = sum(utilities) + sum([taxes, insurance])
        rental_assoc_exp = cashflow_calc.rental_assoc_expenses(rents)
        downpayment = offer*downpayment/100  # downpayment is inserted in percent of offer - but cashflow_calc function takes dollar amount

        # get cashflow values
        test_all = cashflow_calc.cashflow_overview(rents, 
                                                   utilities + [taxes, insurance],
                                                   downpayment, 
                                                   legal, home_insp, 0, bank,
                                                   offer)
        info_col_width = 3
        text_row_height = 3
        info_row_height = 6
        info=[dbc.Row(
                [
                    dbc.Col([
                        dbc.Row([html.Label(id='total_monthly_expenses', children=[f'Mthly. Utilities+'])], style={'height': f'{text_row_height}vh'}),
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
                            html.Label(children=[f"{test_all['real']['ROI_date'].strftime('%Y-%b-%d')}"], style={'text-align': 'center'})
                            ])
                        ], width=3),
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
                            html.Label(children=[f"{test_all['hypo']['ROI_date'].strftime('%Y-%b-%d')}"], style={'text-align': 'center'})
                            ])
                        ], width=3),
                    dbc.Col([
                        dbc.Row([
                            html.Button('Export Results', id='export_results_button', style={"background-color":"inherit", 
                                                                                               "text-align":"center", "margin-top": "10vh",
                                                                                               "width":"50%"})
                        ]),
                        dbc.Row([
                            html.Label(id="export_output", children=[], style={'text-align': 'center', "width":"85%"})
                        ])
                    ], width=3)
                ], justify="around")
        ]
        return info


## month-year-switch
@app.callback(
    [
    Output({'type': 'input','group': MATCH, 'index': MATCH}, 'placeholder'),
    Output({'type': 'switch','group': MATCH, 'index': MATCH}, 'value'),
    Output({'type': 'switch','group': MATCH, 'index': MATCH}, 'children')
    ],
    Input({'type': 'switch','group': MATCH, 'index': MATCH}, 'n_clicks'),
    State({'type': 'switch','group': MATCH, 'index': MATCH}, 'value')
)
def switch_utility_interval(n_clicks, switch_val):
    if n_clicks is None:
        raise PreventUpdate
    else:
        if switch_val=="year":
            print("CONVERTED TO MONTH")
            return ("monthly", "month" , "$/Month")
        else:
            return ("yearly", "year", "$/Year")

if __name__ == '__main__':
    print("Imports done!")
    app.run_server(debug=True)
