package zsl

import (
	"bytes"
	"crypto/sha256"
	"errors"
	"github.com/btcsuite/btcutil/base58"
)

const CSBYTES = 4

var (
	ErrChecksum      = errors.New("checksum error")
	ErrInvalidFormat = errors.New("invalid format: version and/or checksum bytes missing")
)

// Returns the first four bytes of SHA256(SHA256(data)).
func checksum(data []byte) []byte {
	h := sha256.Sum256(data)
	h2 := sha256.Sum256(h[:])
	return h2[:CSBYTES]
}

// `EncodeBase58Check` prepends `version` to `input`, then appends a checksum of
// their concatenation to create the raw encoding. The raw encoding is then
// further encoded using Bitcoin-Base58
// (https://en.bitcoin.it/wiki/Base58Check_encoding).
func encodeBase58Check(input []byte, version []byte) string {
	vlen := len(version)
	b := make([]byte, 0, vlen+len(input)+CSBYTES)
	copy(b, version)
	copy(b[vlen:], input)
	copy(b[len(b)-CSBYTES:], checksum(b))
	return base58.Encode(b)
}

// `DecodeBase58Check` decodes a string that was encoded with
// `EncodeBase58Check` and verifies the checksum.
func decodeBase58Check(input string, vlen int) (result []byte, version []byte, err error) {
	decoded := base58.Decode(input)
	dlen := len(decoded)
	if dlen < (vlen + CSBYTES) {
		return nil, nil, ErrInvalidFormat
	} else if !bytes.Equal(checksum(decoded[:dlen-CSBYTES]), decoded[dlen-CSBYTES:]) {
		return nil, nil, ErrChecksum
	}

	result = decoded[vlen : dlen-CSBYTES]
	version = decoded[:vlen]

	return result, version, nil
}
