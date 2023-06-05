---
title: Protocol Audit Report
author: Racks Labs
date: June 5, 2023
header-includes:
  - \usepackage{titling}
  - \usepackage{graphicx}
---

\begin{titlepage}
    \centering
    \begin{figure}[h]
        \centering
        \includegraphics[width=0.5\textwidth]{logo.pdf} :2
    \end{figure}
    \vspace*{2cm}
    {\Huge\bfseries Protocol Audit Report\par}
    \vspace{1cm}
    {\Large Version 1.0\par}
    \vspace{2cm}
    {\Large\itshape Racks Labs\par}
    \vfill
    {\large \today\par}
\end{titlepage}

\maketitle

<!-- Your report starts here! -->

# NFT Contract Audit Report

## Prepared by: [Rack Labs](https://www.labs.racksmafia.com/)
### Lead Auditors: 
* Alex Encinas 
* Alex Arteaga 
* David Salvatella

---

## Table of Contents
1. [Disclaimer](#disclaimer)
2. [Protocol Summary](#protocol-summary)
3. [Audit Details](#audit-details)
   - [Scope](#scope)
   - [Severity Criteria](#severity-criteria)
   - [Summary of Findings](#summary-of-findings)
   - [Tools Used](#tools-used)
4. [Findings](#findings)
   - [High](#high)
   - [Medium](#medium)
   - [Low](#low)
   - [Informational](#informational)
5. [Gas Optimisation](#gas)

---

## Disclaimer <a name="disclaimer"></a>
*Your disclaimer text goes here.*

## Protocol Summary <a name="protocol-summary"></a>
This is an Ethereum smart contract for a non-fungible token (NFT) named "MarAbiertoToken". It includes features for minting unique tokens, adjusting supply and mint price, and pausing token transfers. The contract owner has special privileges, such as minting without payment and withdrawing Ether from the contract. The contract can emit an event when a new token is minted. It also includes safeguards to prevent minting when all tokens are minted or when insufficient Ether is sent for minting.

## Audit Details <a name="audit-details"></a>
### Scope <a name="scope"></a>
*scope text goes here.*

### Severity Criteria <a name="severity-criteria"></a>
*everity criteria text goes here.*

### Summary of Findings <a name="summary-of-findings"></a>
*summary of findings text goes here.*

### Tools Used <a name="tools-used"></a>
*tools used text goes here.*

## Findings <a name="findings"></a>
### High <a name="high"></a>
*findings go here.*

### Medium <a name="medium"></a>
*medium-severity findings go here.*

### Low <a name="low"></a>
*low-severity findings go here.*

### Informational <a name="informational"></a>
*informational findings go here.*

## Gas Optimisation <a name="gas"></a>
*gas optimisation findings go here.*
