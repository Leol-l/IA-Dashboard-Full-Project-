#!/bin/bash

# Couleurs
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${CYAN}--- Démarrage de l'installation complète ---${NC}"

# 1. Vérification / Installation de Docker
if ! [ -x "$(command -v docker)" ]; then
  echo -e "${GREEN}[1/4] Installation de Docker...${NC}"
  sudo apt-get update
  sudo apt-get install -y docker.io docker-compose
  sudo systemctl start docker
  sudo systemctl enable docker
  # Ajoute l'utilisateur actuel au groupe docker pour éviter le 'sudo' permanent
  sudo usermod -aG docker $USER
else
  echo -e "${GREEN}[1/4] Docker est déjà installé.${NC}"
fi

# 2. Récupération des sous-modules (API et Dashboard)
echo -e "${GREEN}[2/4] Initialisation des sous-modules Git...${NC}"
git submodule update --init --recursive --remote

# 3. Préparation des environnements (Optionnel)
# Si tu as des fichiers .env.example, on peut les copier ici
# cp API-GLPI/.env.example API-GLPI/.env 2>/dev/null

# 4. Lancement de Docker Compose
echo -e "${GREEN}[3/4] Construction et lancement des containers...${NC}"
sudo docker-compose down
sudo docker-compose up -d --build

# 5. Résumé
echo -e "${GREEN}[4/4] Vérification du statut...${NC}"
sudo docker ps

echo -e "${CYAN}--- Installation terminée ! ---${NC}"
echo "Accès Dashboard : http://$(hostname -I | awk '{print $1}')"
echo "Accès API : http://$(hostname -I | awk '{print $1}'):3000"