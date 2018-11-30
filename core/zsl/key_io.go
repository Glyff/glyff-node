package zsl

var (
	ProdSpendingKey    = []byte{0xAB, 0x36}
	TestSpendingKey    = []byte{0xAC, 0x08}
	ProdPaymentAddress = []byte{0x16, 0x9A}
	TestPaymentAddress = []byte{0x16, 0xB6}
	ProdViewingKey     = []byte{0xA8, 0xAB, 0xD3}
	TestViewingKey     = []byte{0xA8, 0xAC, 0x0C}
)

func EncodeShieldedPaymentAddress(a_pk, pk_enc []byte) string {
	input := make([]byte, 0, 64)
	copy(input, a_pk)
	copy(input[32:], pk_enc)
	return encodeBase58Check(input, TestPaymentAddress)
}

func DecodeShieldedPaymentAddress(addr string) (a_pk, pk_enc, version []byte, err error) {
	result, version, err := decodeBase58Check(addr, len(TestPaymentAddress))
	if err != nil {
		return nil, nil, nil, err
	}

	a_pk = result[:32]
	pk_enc = result[32:]
	return
}

func EncodeIncomingViewingKey(a_pk, sk_enc []byte) string {
	input := make([]byte, 0, 64)
	copy(input, a_pk)
	copy(input[32:], sk_enc)
	return encodeBase58Check(input, TestViewingKey)
}

func DecodeViewingKey(addr string) (a_pk, sk_enc, version []byte, err error) {
	result, version, err := decodeBase58Check(addr, len(TestViewingKey))
	if err != nil {
		return nil, nil, nil, err
	}

	a_pk = result[:32]
	sk_enc = result[32:]
	return
}

func EncodeSpendingKey(a_sk []byte) string {
	return encodeBase58Check(a_sk, TestSpendingKey)
}

func DecodeSpendingKey(addr string) (a_sk, version []byte, err error) {
	return decodeBase58Check(addr, len(TestSpendingKey))
}
