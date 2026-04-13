# Progetto Database E-Commerce

## Descrizione

Questo progetto rappresenta un sistema di gestione e-commerce completo, attraverso la creazione di un database relazionale e l'integrazione con un'interfaccia web.

Il sistema gestisce:
utenti
prodotti
categorie
ordini
dettagli degli ordini

Include sia la parte backend (database SQL) che una interfaccia frontend dinamica pubblicata su GitHub Pages.


## Obiettivi del progetto

* Progettare un database relazionale strutturato
* Utilizzare relazioni tramite chiavi esterne (Foreign Key)
* Scrivere query SQL complesse con JOIN
* Ottimizzare le performance con indici
* Integrare il database con una UI web
* Mostrare dati reali tramite API

## Struttura del Database

### Tabelle principali:

`users`
`products`
`categories`
`orders`
`order_items`

### Relazioni:

Un utente può avere più ordini
Un ordine contiene più prodotti (tramite `order_items`)
Ogni prodotto appartiene a una categoria

## Tecnologie utilizzate

### Database

PostgreSQL (Supabase)

### Frontend

HTML
CSS
JavaScript (Vanilla)

### Hosting

GitHub Pages (frontend)
Supabase (database + API)

## Architettura

Frontend (GitHub Pages)
JavaScript (fetch dati)
Supabase API
Database PostgreSQL

## Funzionalità principali

Visualizzazione utenti
Visualizzazione prodotti
Lista ordini
Dashboard con dati aggregati
Query JOIN tramite viste SQL (`order_summary`)


## Ottimizzazione

Indici su chiavi esterne
Indice composito su:

  ```
  orders(user_id, status, order_date DESC)
  ```
Uso di viste per semplificare query complesse
Esempi di `EXPLAIN ANALYZE`

## Sicurezza

Row Level Security (RLS) attiva su Supabase
Accesso in sola lettura tramite `anon key`
Nessuna esposizione di credenziali sensibili

## Demo

(https://m-monea.github.io/database_e-commerce_base/)
