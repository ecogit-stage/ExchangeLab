#### Terraform + Azure + Active Directory + Exchange + IIS ARR
En el siguiente laboratorio vamos a implementar una Exchange 2016 en alta disponibilidad en Azure mediante terraform. Este deploy contiene herramientas de alta disponibilidad como Azure Load Balancing, IIS AAR, DFSR y Exchange DAG (Database  Availability Group).

Crearemos 6 VMs con Windows Server 2016 en una virtual Network con dos subnets: una subnet de DMZ y una subnet de LAN.


##### Detalle de la Infraestructura:

1. Un virtual Network **lab-vnet** con el espacio de direcciones 10.0.0.0/16
2. Dos subnets dentro de la vNet **lab-vnet**
    * Subnet **DMZ**: 10.0.1.0/24
    * Subnet **LAN**: 10.0.2.0/24
3. Dos servidores de IIS ARR que serán los proxy reversos y balanceo de carga interno hacia los servidores Exchange 2016. 
   * Los servidores tienen dos nics: una en subnet **DMZ** y la otra en subnet **LAN**.
   * Se utilizará el rol DFS-R para utilizar "shared configuration" de IIS y mantener ambos servidores identicos.
4. Dos servidores destinados a controladores de dominio con una nic conectada a la subnet **LAN**.
5. Dos servidores para Exchange Server 2016.
   * El witness primario y secundario serán carpeta compartidas en los controladores de dominio.
   * Se formará un DAG y las bases de datos estarán replicadas.
6. Azure Load Balance para balancear el tráfico externo hacia los IIS ARR.

| Virtual Machine | Hostname     | IP Address                | Role              |
| ----------------|:------------:|:--------------------------|:------------------|
| lab-dc-1        | lab-lan-dc-1 | 10.0.2.5                  | Domain Controller |
| lab-dc-2        | lab-lan-dc-2 | 10.0.2.6                  | Domain Controller |
| lab-mx-1        | lab-lan-ex-1 | 10.0.2.20                 | Exchange Server   |
| lab-mx-2        | lab-lan-ex-2 | 10.0.2.21                 | Exchange Server   |
| lab-dmz-0       | lab-dmz-web-1| 10.0.1.10 - 10.0.2.10     | IIS ARR DMZ       |
| lab-dmz-1       | lab-dmz-web-2| 10.0.1.11 - 10.0.2.11     | IIS ARR DMZ       |