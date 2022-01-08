def mortgage_calc(P, i, n, period='y'):
    """
    Calculates monthly mortage payments based on desired parameters.
    
    Params:
        P (float) - total loan amount
        i (float) - interest rate as monthly percentage
        n (int) - The total amount of years in your timeline for paying off your mortgage
        period (str) - input for mortgage period (default: year)
        
    Returns:
        M - total monthly payment
     """
    n = n*12 if period =="y" else n*365 if period=="d" else n if period=="m" else None
    M = P*(i*(1 + i)**n) / ((1 + i)**n - 1)
    return M


def remaining_balance(P, i, n, p):
    """
    calculates monthly mortage payments based on desired parameters.
    
    Params:
        P (float) - total loan amount
        i (float) - interest rate as monthly percentage
        n (int) - The total amount of months in your timeline for paying off your mortgage
        period (str) - input for mortgage period (default: year)
        p (int) - year or month after which to calculate remaining loan balance
        
    Returns:
        (B, already_paid) - remaining loan balance, balance already pais
     """
    B = P*((1 + i)**n - (1 + i)**p)/((1 + i)**n - 1)
    return B, P-B


def loan_balance_overview(P, i, n, period='y', yoi=[5, 10, 15, 20, 25]):
    """
    calculates monthly mortage payments based on desired parameters.
    
    Params:
        P (float) - total loan amount
        i (float) - interest rate as monthly percentage
        n (int) - The total amount of years in your timeline for paying off your mortgage
        period (str) - input for mortgage period (default: year)
        yoi (list) - years after which to calculate remaining loan balance for
        
    Returns:
        dict - remaining balance after years listed in yoi
     """
    
    n = n*12 if period =="y" else n*365 if period=="d" else n if period=="m" else None
    moi = [i*12 for i in yoi]
    return {year:remaining_balance(P, i, n, month) for month, year in zip(moi, yoi)}


def total_cost(P, i, n):
    """
    Calculates the total cost of the mortgage (loan plus interests).

    Params:
        P (float) - total loan amount
        i (float) - interest rate as monthly percentage
        n (int) - The total amount of years in your timeline for paying off your mortgage
        
    Returns:
        C (float) - total cost of mortgage
    """
    monthly_payment = mortgage_calc(P, i, n)
    return monthly_payment*n*12


