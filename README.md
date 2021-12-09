# real_xstate
Plotly Dash app that evaluates potential real estate investment deals and keeps track of current investments.
The app takes all impotrant metrics (such as mortgage term, property offer, utility costs, income from rent, taxes etc) and creates a investment full under realistic  ('real') and optimal ('hypo') conditions.<br>
Values calculated to evaluate if a property is a good investment include: __ROI, cash-on-cash ROI, breakeven date, cashflow__.<br>
Result can be exported to a text file by hitting the dedicated button.
<br><br>

Installation:<br>

Clone repo: <br>
`git clone https://github.com/lasupernova/real_xstate.git`

Install dependencies:<br>
`pip install -r requirements.txt`

Usage:<br>

Running the following command will run flsak contanign a Plotly Dash app:
`python app.py`
<br><br>
Open app in browser (while the command above is running):
Open to Browser > Go to Localhost (port 8050) `http://127.0.0.1:8050/`
<br><br>

<img alt="User Input Process" title="Date Dec 5th 2021" src="static/demo/realXstate_evaluationPage.gif" width="1200" height="600">
