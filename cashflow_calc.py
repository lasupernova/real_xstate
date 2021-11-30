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


def total_expenses_MO(rents:list, costs:list, hypo=False):
    """
    Calculates total monthly expenses (hypo or 'real'), including: 
    rent associated expenses and costs (utilities, taxes, HOA, insurance...).

    Params:
        rents (list) - list of monthly rents in property
        costs (list) - list of non-rental associated monthly costs
        hypo (bool)  - calculates hypo cash flow when True and 'real' cash flow when False (default: False)

    Returns
        float
    """
    other_exp = sum(costs)
    if not hypo:
        return other_exp
    else:
        rent_assoc_exp = sum(list(rental_assoc_expenses(rents)))
        return rent_assoc_exp+other_exp


def calculate_net_op_costs_MO(costs:list):
    """
    Returns monthly net operating costs
    """
    return sum(costs)/12


def calculate_net_op_income(rents:list, costs:float, period:str):
    """
    Returns monthly net operating income

    Params:
        rents (list)    - list of monthly rents in property
        costs (float)   - costs (as calculated by calculate_net_op_costs_MO())
        period (string) - indicates if monthly or yearly net op income should be calculated (options: "y" -yearly, "m" -monthly)

    Returns:
        float
    """
    if period.lower() == "m":
        return sum(rents) - costs
    elif period.lower()=="y":
        return sum(rents)*12 - costs*12
    else:
        raise ValueError(f'Please pass "y" or "m" for "period"!\nCurrently passed: "{period}"')


def calculate_cashflow(rents:list, expenses:float, period:str="m"):
    """
    Returns monthly net operating income

    Params:
        rents (list)       - list of monthly rents in property
        expenses (float)   - expenses (as calculated by calculate_net_op_costs_MO())
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
    return sum(downpayment, legal, home_insp, prop_mgmt_signup, bank)


def coc_ROI(cashflow_YR, investment):
    """
    Calculates cash-on-cash-ROI (a percent value).

    Params
        cashflow_YR (float) - total yearly cashflow
        investment (float)  - total investment (as calculated by total_investment())

    Returns
        float
    """
    return cashflow_YR/investment


if __name__=="__main__":
    print(rental_assoc_expenses([750, 900]))

