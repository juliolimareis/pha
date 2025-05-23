class_name Cryptography

var crypto = Crypto.new()
var key = CryptoKey.new()
var cert = X509Certificate.new()

var hashPass = "75e2d3d167131882b8b07579f9e2c65b"

func _init():
	key = crypto.generate_rsa(4096)
	print(key.save_to_string(false))
#	var encrypted = crypto.encrypt( key, "escondido".to_utf8())
#	var decrypted = crypto.decrypt(key, encrypted)
