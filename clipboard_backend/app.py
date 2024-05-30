from flask import Flask, render_template, request, redirect, url_for, flash, send_from_directory
import os
from werkzeug.utils import secure_filename
import json

UPLOAD_FOLDER = './files'
ALLOWED_EXTENSIONS = {'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif', '*'}

app = Flask(__name__)
app.config['SECRET_KEY'] = 'myfuckingsecurekeyhehe'  # Change this to a secure secret key
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


# relaxing security for more useability
from flask_cors import CORS
CORS(app, resources={r"/*": {"origins": "*"}}) # allows requests from all origins


data = {}

# test data
"""
data = {
    'mujtaba': [
        {'file': 'url'},
        {'text': 'lorem...'},
        {'file': 'irl'}, # filename will be url's last name with extension
    ]
}
"""



MAX_TEXT_SIZE = 32 * 1024 # 32 KB
MAX_PIN_SIZE = 32 # 32 bytes
MAX_FILE_SIZE = 32 * 1024 * 1024 # 32 MB

MIN_PIN_SIZE = 4 # 4 bytes


@app.route('/', methods=['POST'])
def index():
    if request.method == 'POST':
         
        pin : str = request.json['pin'].lower() # Aysh vs aysh

        if len(pin) > MAX_PIN_SIZE:
            return json.dumps({'error': 'PIN size too large'})
        if len(pin) < MIN_PIN_SIZE:
            return json.dumps({'error': 'PIN size too small'})

        if pin not in data:
            data[pin] = [] # create data/page for him
        
        response = {
            'pin': pin,
        }

        return json.dumps(response)


@app.route('/clipboard/<pin>', methods=['GET', 'POST'])
def clipboard(pin):
    pin = pin.lower()
    if request.method == 'GET':
        if pin not in data:
            return json.dumps({'error': 'Invalid PIN'})
        
        return json.dumps(data[pin])



@app.route('/upload/<pin>', methods=['POST'])
def upload(pin):
    pin = pin.lower()
    if pin not in data:
        return json.dumps({'error': 'Invalid PIN'})###################################################
    # check if the post request has the file part
    if 'file' not in request.files:
        return  json.dumps({'error': 'No file part'})
    
    file = request.files['file']
    # If the user does not select a file, the browser submits an
    # empty file without a filename.
    if file.filename == '':
        return json.dumps({'error': 'No selected file'})
    
    if file and allowed_file(file.filename):
        # Check file size without reading its content explicitly
        file.seek(0, os.SEEK_END)  # Move file pointer to the end
        file_size = file.tell()  # Get file size
        file.seek(0)  # Reset file pointer to the beginning
        if file_size > MAX_FILE_SIZE:
            return json.dumps({'error': 'File size too large'})
        
        filename = secure_filename(file.filename)
        upload_dir = ensure_upload_dir_exists(pin)  # Ensure upload directory exists

        # if same file name exists, append a number to the filename before the extension
        i = 0
        while os.path.exists(os.path.join(upload_dir, filename)):
            i += 1
            name, ext = os.path.splitext(filename)
            # if there exists a number just before the extension, update it
            # but if there is no number, append a number to the filename
            if name[-1].isdigit() and name[-2] == '_':
                name = name[:-2] + '_' + str(i)
            else:
                name = name + '_' + str(i)
            filename = name + ext

        file.save(os.path.join(upload_dir, filename))
        data[pin].append({'file': filename})
        return json.dumps({'success': 'File uploaded successfully'})
    
    return json.dumps({'error': 'Invalid file extension'})



@app.route('/files/<pin>/<filename>', methods=['GET'])
def download(pin, filename):
    pin = pin.lower()
    if pin not in data:
        return json.dumps({'error': 'Invalid PIN'})
    upload_dir = ensure_upload_dir_exists(pin)
    return send_from_directory(upload_dir, filename, as_attachment=True)



@app.route('/texts/<pin>/<index>', methods=['POST'])
def update_text(pin, index):
    pin = pin.lower()
    if pin not in data:
        return json.dumps({'error': 'Invalid PIN'})
    index = int(index)
    text = request.json['text']
    if len(text) > MAX_TEXT_SIZE:
        return json.dumps({'error': 'Text size too large'})
    if index == -1: # create new text entry if index is -1
        data[pin].append({'text': text})
    else:
        data[pin][index] = {'text': text}
    return json.dumps({'success': 'Text updated successfully'})



@app.route('/delete/<pin>/<index>', methods=['GET'])
def delete(pin, index):
    pin = pin.lower()
    if pin not in data:
        return json.dumps({'error': 'Invalid PIN'})
    index = int(index)
    if index < len(data[pin]):
        if 'file' in data[pin][index]:
            upload_dir = ensure_upload_dir_exists(pin)
            file_path = os.path.join(upload_dir, data[pin][index]['file'])
            if os.path.exists(file_path):
                os.remove(file_path)
            else:
                return json.dumps({'error': 'File does not exist'})
        data[pin].pop(index)
    return json.dumps({'success': 'Entry deleted successfully'})


# Ensure the target upload directory exists
def ensure_upload_dir_exists(pin):
    upload_dir = os.path.join(app.config['UPLOAD_FOLDER'], str(pin))
    os.makedirs(upload_dir, exist_ok=True)
    return upload_dir

def allowed_file(filename):
    if '*' in ALLOWED_EXTENSIONS:
        return True
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS



@app.errorhandler(404)
def page_not_found(e):
    return json.dumps({'error': 'Invalid URL'}), 404

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

@app.route('/systemstatus', methods=['GET'])
def system_status():
    # all stats here
    total_pins = len(data)
    total_files = 0
    total_text = 0
    for pin in data:
        for entry in data[pin]:
            if 'file' in entry:
                total_files += 1
            elif 'text' in entry:
                total_text += 1
    return json.dumps({'total_pins': total_pins, 'total_files': total_files, 'total_text': total_text}, indent=4)


# useful during updates when migration is needed
@app.route('/alldata', methods=['GET'])
def all_data():
    return json.dumps(data, indent=4)

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=7860)