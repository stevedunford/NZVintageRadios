from flask import Flask, flash, session, request, render_template, url_for

app = Flask(__name__)
app.secret_key = "~1\xe4\xa77b\x04\x0c\xcc1\x89\xb9\xce\x1c\xa1H\xc7\x82\xe2\xc3\x97\xe9\x13z"

@app.route("/")
def index():
    return render_template("index.html")


@app.route("/echo", methods=['POST'])
def echo():
    flash(request.form['text'])
    flash("Hi, I'm noodles")
    return '<a href="/">HAHAHA</a> You said: '

if __name__ == "__main__":
    app.run(debug=True)
