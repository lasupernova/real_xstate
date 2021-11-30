import mortgage_calc
import datetime

now = datetime.datetime.now()

def rental_assoc_expenses(rents:list):
    """
    Calculates rent associated expenses.

    Params:
        rents (list)    - list of monthly rents in property

    Returns
        x, y, z (tuple) - tuple containing x=property managment fees, y=vacancy and z=capital expenditures
    """
    total_rent = sum(rents)
    prop_mgmt = total_rent*0.09
    vacancy_loss = capital_exp = total_rent*0.05
    return prop_mgmt, vacancy_loss, capital_exp


def total_expenses_MO(rents:list, costs:list, monthly_payment:float, hypo:bool=False, rent_period="m", cost_period="y"):
    """
    Calculates total monthly expenses (hypo or 'real'), including: 
    rent associated expenses and costs (utilities, taxes, HOA, insurance...).
    INCLUDES mortgage payments

    Params:
        rents (list)            - list of monthly rents in property
        costs (list)            - list of non-rental associated  costs
        monthly_payment (float) - amount of monthly motgage payment
        hypo (bool)             - calculates hypo cash flow when True and 'real' cash flow when False (default: False)

    Returns
        float
    """
    # control for different periods that values cover based on corresponding params
    if rent_period == "y":
        rents = [rent/12 for rent in rents]
    if cost_period == "y":
        costs = [cost/12 for cost in costs]

    other_exp = sum(costs)
    if hypo:
        rent_assoc_exp = rental_assoc_expenses(rents)[0]  # returns tuple with 3 values (mgmt fee, vacancy and capital expenditure)
        return rent_assoc_exp+other_exp+monthly_payment
    else:
        rent_assoc_exp = sum(list(rental_assoc_expenses(rents)))
        return rent_assoc_exp+other_exp+monthly_payment


def calculate_net_op_costs_MO(rents:list, costs:list, hypo:bool=False, rent_period="m", cost_period="y"):
    """
    Calculates total monthly expenses (hypo or 'real'), including: 
    rent associated expenses and costs (utilities, taxes, HOA, insurance...).
    INCLUDES mortgage payments

    Params:
        rents (list)            - list of monthly rents in property
        costs (list)            - list of non-rental associated monthly costs
        hypo (bool)             - calculates hypo cash flow when True and 'real' cash flow when False (default: False)

    Returns
        float
    """
    # control for different periods that values cover based on corresponding params
    if rent_period == "y":
        rents = [rent/12 for rent in rents]
    if cost_period == "y":
        costs = [cost/12 for cost in costs]

    other_exp = sum(costs)
    # calculate real OR hypo net operating costs based on 'hypo'-param
    if hypo:
        rent_assoc_exp = rental_assoc_expenses(rents)[0]  # returns tuple with 3 values (mgmt fee, vacancy and capital expenditure)
        return rent_assoc_exp+other_exp
    else:
        rent_assoc_exp = sum(list(rental_assoc_expenses(rents)))
        return rent_assoc_exp+other_exp



def calculate_net_op_income(rents:list, net_op_costs:float, period:str):
    """
    Returns monthly net operating income

    Params:
        rents (list)    - list of monthly rents in property
        net_op_costs (float)   - costs (as calculated by calculate_net_op_costs_MO())
        period (string) - indicates if monthly or yearly net op income should be calculated (options: "y" -yearly, "m" -monthly)

    Returns:
        float
    """
    if period.lower() == "m":
        return sum(rents) - net_op_costs
    elif period.lower()=="y":
        return sum(rents)*12 - net_op_costs*12
    else:
        raise ValueError(f'Please pass "y" or "m" for "period"!\nCurrently passed: "{period}"')


def calculate_cashflow(rents:list, expenses:float, period:str="m"):
    """
    Returns monthly net operating income

    Params:
        rents (list)       - list of monthly rents in property
        expenses (float)   - expenses (as calculated by total_expenses_MO())
        period (string)    - indicates if monthly or yearly net op income should be calculated (options: "y" -yearly, "m" -monthly)

    Returns:
        float
    """
    if period.lower() == "m":
        return sum(rents) - expenses
    elif period.lower()=="y":
        return (sum(rents) - expenses)*12
    else:
        raise ValueError(f'Please pass "y" or "m" for "period"!\nCurrently passed: "{period}"')


def total_investment(downpayment, legal, home_insp, prop_mgmt_signup, bank):
    """
    Calculates total investment.

    Params:
        downpayment (float) - downpayment projected for property
        legal (float) - legal fees projected for property
        home_insp (float) - home inspection costs projected for property 
        prop_mgmt_signup (float) - propeerty management signup fees projected for property
        bank (float) - bank fees projected for property

    Returns
        float
    """
    return sum([downpayment, legal, home_insp, prop_mgmt_signup, bank])


def calculate_coc_ROI(cashflow_YR, investment):
    """
    Calculates cash-on-cash-ROI (a percent value).

    Params
        cashflow_YR (float) - total yearly cashflow
        investment (float)  - total investment (as calculated by total_investment())

    Returns
        float
    """
    return cashflow_YR/investment


def calculate_rent_to_price(rents:list, offer:float):
    """
    Calculates rent-to-price-ratio (a percent value).

    Params
        rents (list)  - list of monthly rents in property
        offer (float) - projected offer amount for property

    Returns
        float
    """
    return sum(rents)/offer


def calculate_cap_rate(monthly_payment:float, cashflow_YR:float, offer:float):
    """
    Calculates cap-rate (a percent value).

    Params
        monthly_payment (float)  - list of monthly rents in property
        cashflow_YR (float)      - total yearly cashflow
        offer (float)            - projected offer amount for property

    Returns
        float
    """
    return ((monthly_payment*12)+cashflow_YR)/offer


def calculate_RTI(investment:float, cashflow_YR:float):
    """
    Calculates return on total investment (= break-even point).

    Params
        investment (float)  - total investment (as calculated by total_investment())
        cashflow_YR (float)  - total yearly cashflow

    Returns
        float
    """
    return investment/cashflow_YR


def cashflow_overview(rents:list, costs:list, downpayment, legal, home_insp, prop_mgmt_signup, bank, offer):
    loan_amount = offer-downpayment
    monthly_payment = mortgage_calc.mortgage_calc(P=loan_amount, i=0.03375/12, n=30)
    rental_assoc_exp = rental_assoc_expenses(rents)
    tot_exp_MO_real = total_expenses_MO(rents, costs, monthly_payment)
    tot_exp_MO_hypo = total_expenses_MO(rents, costs, monthly_payment, hypo=True)
    op_expenses_real = calculate_net_op_costs_MO(rents, costs)
    op_expenses_hypo = calculate_net_op_costs_MO(rents, costs, hypo=True)
    income_MO_real = calculate_net_op_income(rents, op_expenses_real, "m")
    income_MO_hypo = calculate_net_op_income(rents, op_expenses_hypo, "m")
    income_YR_real = calculate_net_op_income(rents, op_expenses_real, "y")
    income_YR_hypo = calculate_net_op_income(rents, op_expenses_hypo, "y")
    cashflow_MO_real = calculate_cashflow(rents, tot_exp_MO_real)
    cashflow_YR_real = calculate_cashflow(rents, tot_exp_MO_real, period="y")
    cashflow_MO_hypo = calculate_cashflow(rents, tot_exp_MO_hypo)
    cashflow_YR_hypo = calculate_cashflow(rents, tot_exp_MO_hypo, period="y")
    investment = total_investment(downpayment, legal, home_insp, prop_mgmt_signup, bank)
    coc_ROI_real = calculate_coc_ROI(cashflow_YR_real, investment)
    coc_ROI_hypo = calculate_coc_ROI(cashflow_YR_hypo, investment)
    rent_to_price = calculate_rent_to_price(rents, offer)
    cap_rate_real = calculate_cap_rate(monthly_payment, cashflow_YR_real, offer)
    breakeven_real = calculate_RTI(investment, cashflow_YR_real)
    cap_rate_hypo = calculate_cap_rate(monthly_payment, cashflow_YR_hypo, offer)
    breakeven_hypo = calculate_RTI(investment, cashflow_YR_hypo)
    print(f"""
    ###########################################
                 CASHFLOW OVERVIEW
    ###########################################
                                  

    General Info:
        Loan Amount: $ {loan_amount}
        Downpayment: $ {downpayment}
        Monthly Mortgage Payment: $ {monthly_payment:.2f}
        Total Investment: $ {investment}


    General Expenses:
        Rental Associated Expenses: $ {rental_assoc_exp}


    General Income:
        Rents: {", ".join(['$ '+str(rent) for rent in rents])}


    -------------------------------------------

    *******************REAL:*******************

    [+] Income:
            Net Operating Income: $ {income_MO_real:.2f} (MO) / ${income_YR_real:.2f} (YR)

    [-] Expenses:
            Net Operating Costs: $ {op_expenses_real:.2f}
            Total Monthly Expenses: $ {tot_exp_MO_real:.2f}

    [i] Cashflow Stats:
            Cashflow: $ {cashflow_MO_real:.2f} (MO) / $ {cashflow_YR_real:.2f} (YR)
            Cash-on-cash ROI (year): {coc_ROI_real:.2%}
            Rent-to-price Ratio: {rent_to_price:.2%}
            Cap rate: {cap_rate_real:.2%}
            ROI: {breakeven_real:.2f} years 
            Breakeven Date: {now + datetime.timedelta(days=breakeven_real*365)}
    
    --------------------------------------------
    
    *******************HYPO:*******************

    [+] Income:
            Net Operating Income: $ {income_MO_hypo:.2f} (MO) / ${income_YR_hypo:.2f} (YR)

    [-] Expenses:
            Net Operating Costs: $ {op_expenses_hypo:.2f}
            Total Monthly Expenses: $ {tot_exp_MO_hypo:.2f}

    [i] Cashflow Stats:
            Cashflow: $ {cashflow_MO_hypo:.2f} (MO) / $ {cashflow_YR_hypo:.2f} (YR)
            Cash-on-cash ROI (year): {coc_ROI_hypo:.2%}
            Rent-to-price Ratio: {rent_to_price:.2%}
            Cap rate: {cap_rate_hypo:.2%}
            ROI: {breakeven_hypo:.2f} years 
            Breakeven Date: {now + datetime.timedelta(days=breakeven_hypo*365)}
    
    --------------------------------------------
    """)


if __name__=="__main__":
    cashflow_overview([750, 850], [400, 3157, 400, 400,400], 20500, 700, 450, 0, 9260, 82000)

