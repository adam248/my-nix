
  # Cert Auth step-ca
  services.step-ca = {
    # DNS: ca.nyx.home
    enable = false;
    intermediatePasswordFile = "/etc/nixos/step-ca-pass";
    address = "127.0.0.1";
    port = 2443;
    openFirewall = true;
    settings = builtins.fromJSON ''

{
	"root": "/var/lib/private/step-ca/certs/root_ca.crt",
	"federatedRoots": null,
	"crt": "/var/lib/private/step-ca/certs/intermediate_ca.crt",
	"key": "/var/lib/private/step-ca/secrets/intermediate_ca_key",
	"insecureAddress": "",
	"dnsNames": [
		"192.168.0.3",
		"ca.nyx.home"
	],
	"logger": {
		"format": "text"
	},
	"db": {
		"type": "badgerv2",
		"dataSource": "/var/lib/private/step-ca/db",
		"badgerFileLoadingMode": ""
	},
	"authority": {
		"provisioners": [
			{
				"type": "JWK",
				"name": "adam@nyx.home",
				"key": {
					"use": "sig",
					"kty": "EC",
					"kid": "9tNI0q318tDooHxlfpfuAkqjAzXulllzViRDDcHZies",
					"crv": "P-256",
					"alg": "ES256",
					"x": "SuzG6AIcKC6sP2SO1zfnsYMQ2C5sty7jsb1MUmdb4kM",
					"y": "ygaPJ9fuqQrUQ5o3JmHdpBvwspON0XAeIVtfsLAIYnA"
				},
				"encryptedKey": "eyJhbGciOiJQQkVTMi1IUzI1NitBMTI4S1ciLCJjdHkiOiJqd2sranNvbiIsImVuYyI6IkEyNTZHQ00iLCJwMmMiOjYwMDAwMCwicDJzIjoiX1lrMk9Ud0ZNZldMZVFiMm9ybDhJdyJ9.TD7AknjenWl2QZ75AfLGzv5WdjQjf21nWZL6dDy4CYTtZjhtusXH_A.2OcmrMUnhWk5gOma.9HYvNXo0EdEWOVUNW-uufpsQKRWJzM4zmAJysiSOeneXS0i6VK2eNCTnNvPsocasqJ8Vs2htJTIDVa07ncz8u6tuPEZvHMVmLfSW41-pOM_svB9iDvL4Qgu6ig0JN5h74jGMkBBMFzL2jedt_gk7rmdCm3Vq2i2XkAm98ckNh51cU1WHpkuPuVZ4ofjVyQWlf8eBXyeMcBmV1lFOVyfdUArHBV3FOwLHU4OAQrMUT4YAxB_xD-2zR7C4Q_UVURo8uhwFAJ2fyMR-qhK5eRVynqNcUoodzUIpjVeus1AQ7A7D1OIHatIoGq6bU8LWTQ-E2IYjItDZ7n9K1ylm2PQ.wW3z6_XQWFSsbFxkgm3rEA"
			}
		]
	},
	"tls": {
		"cipherSuites": [
			"TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256",
			"TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
		],
		"minVersion": 1.2,
		"maxVersion": 1.3,
		"renegotiation": false
	}
}
    '';
  };
