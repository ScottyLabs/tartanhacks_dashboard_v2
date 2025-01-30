import requests, qrcode, os

url = "https://backend.tartanhacks.com/check-in"
ciis = requests.get(url).json()
names = list(map(lambda x: x['name'], ciis))
ids = list(map(lambda x: x['_id'], ciis))

path = os.path.join(os.getcwd(), "tartanhacks_qrcodes/")

if os.path.exists(path):
	for file in os.listdir(path):
		os.remove(path + file)
	os.rmdir(path)

if (not os.path.exists(path)):
	os.mkdir(path)

	for i in range (len(ciis)):
		qr = qrcode.QRCode(
				version=1,
				error_correction=qrcode.constants.ERROR_CORRECT_L,
				box_size=10,
				border=4,
		)
		qr.add_data(ids[i])
		qr.make(fit=True)

		img = qr.make_image(fill_color=(7, 5, 76), back_color=(255, 199, 56))
		# img = qr.make_image(ids[i], fill_color=(7, 5, 76), back_color=(255, 199, 56))
		img.save(path + names[i].replace("/", "") + ".jpg")
		
else:
	print("delete tartanhacks_qrcodes folder")
