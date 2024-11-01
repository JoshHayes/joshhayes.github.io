+++
author = "Joshua Hayes"
title = "Doob-Dynkin Lemma"
date = 2024-11-01
[taxonomies]
categories = ["Mathematics"]
tags = ["probability theory", "category theory"]
+++

Given measurable functions \\(f\\), \\(g\\) on a common space \\(\Omega\\), we
say that \\(f\\) is \\(g\\)-measurable if the induced \\(\sigma\\)-algebras
satisfy \\(\sigma(f) \subset \sigma(g)\\). If \\(f \colon \Omega \to S\\) is a
function and \\((S, \mathcal{S})\\) is a measurable space, then
$$\sigma(f) = \left\\{ f^{-1}A \mid A \in \mathcal{S} \right\\}$$
is the smallest
\\(\sigma\\)-algebra on \\(\Omega\\) such that \\(f\\) is
\\(\sigma(f)/\mathcal{S}\\)-measurable.

Suppose we have another measurable function \\(g \colon \Omega \to T\\)
where \\((T, \mathcal{T})\\) is a measurable space. Under what conditions is
\\(f\\) is \\(g\\)-measurable?

<!-- more -->

This requires that \\(\sigma(f) \subset \sigma(g)\\), which means in some
sense that the \\(\sigma\\)-algebra \\(\mathcal{S}\\) on \\(S\\) the domain of \\(f\\)
cannot be too "coarse". The other condition turns out to be that \\(f\\)
must be a function of \\(g\\).

## Universal property of induced \\(\sigma\\)-algebras

Something like: Let \\(X\\) and \\(Y\\) be random variables. Then \\(Y\\) is
\\(\sigma(X)\\)-measurable if and only if \\(Y\\) is a function of \\(X\\).
