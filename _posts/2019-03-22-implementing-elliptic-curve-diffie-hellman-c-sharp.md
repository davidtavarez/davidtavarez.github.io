---
layout: post
title:  "Implementing Elliptic-curve Diffie–Hellman Key Exchange 
Algorithm using C# (cross-platform)"
date:   2019-03-22 01:00:00 -0400
categories:
  - Code
tags:
  - C#
  - cryptography
  - mono
---
The Diffie-Hellman key exchange algorithm is a method to securely establish a shared secret between two parties (Alice and Bob). **Elliptic-curve Diffie–Hellman (ECDH)** is allows the two parties, each having an elliptic-curve public–private key pair, to establish the shared secret. This shared secret may be directly used as a key, or to derive another key. The key, or the derived key, can then be used to encrypt subsequent communications using a symmetric-key cipher. It is a variant of the Diffie–Hellman protocol using elliptic-curve cryptography. 

## Diffie-Hellman

The Diffie-Hellman key exchange is a way for people to secretly share information. When two people want to use cryptography, they often only have an insecure channel to exchange information. Martin Hellman, Whitfield Diffie and Ralph Merkle developed a protocol that allows this information exchange over an insecure channel. The resulting protocol has become known as Diffie-Hellman key exchange. Sometimes it is called Diffie-Hellman key agreement, Diffie-Hellman key establishment, Diffie-Hellman key negotiation or Exponential key exchange. Using this protocol, both parties agree on a secret key. They use this key to encrypt their communication using a symmetric-key cipher.

The scheme was first published by Whitfield Diffie and Martin Hellman in 1976. Diffie-Hellman key agreement itself is an anonymous (non-authenticated) key-agreement protocol, it provides the basis for a variety of authenticated protocols, and is used to provide perfect forward secrecy in Transport Layer Security's short-lived modes. 

![Diffie-Hellman](https://www.practicalnetworking.net/wp-content/uploads/2015/11/dh-revised-1024x751.png)

## Elliptic curve

