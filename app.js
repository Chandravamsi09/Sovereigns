// Sovereigns 4X Strategy Game Engine - Web Engine
class SovereignsEngine {
    constructor() {
        this.width = 18;
        this.height = 14;
        this.hexRadius = 32;
        this.grid = [];
        this.units = [];
        this.cities = [];
        
        this.turn = 1;
        this.activePlayer = 0; // 0 = Player, 1 = AI
        
        this.resources = {
            gold: 100,
            goldYield: 10,
            science: 0,
            scienceYield: 5,
            culture: 0,
            cultureYield: 2
        };

        this.techs = [
            { id: "agriculture", name: "Agriculture", cost: 30, reqs: [], unlocked: true },
            { id: "pottery", name: "Pottery", cost: 50, reqs: ["agriculture"], unlocked: false },
            { id: "mining", name: "Mining", cost: 50, reqs: ["agriculture"], unlocked: false },
            { id: "writing", name: "Writing", cost: 80, reqs: ["pottery"], unlocked: false },
            { id: "bronze_working", name: "Bronze Working", cost: 80, reqs: ["mining"], unlocked: false },
            { id: "mathematics", name: "Mathematics", cost: 140, reqs: ["writing"], unlocked: false }
        ];

        this.activeResearch = "pottery";
        this.researchProgress = 0;

        this.fowEnabled = true;
        this.selectedTile = null;

        this.initCanvas();
        this.generateMap();
        this.spawnInitialUnits();
        this.bindEvents();
        this.render();
    }

    initCanvas() {
        this.canvas = document.getElementById("hex-canvas");
        this.ctx = this.canvas.getContext("2d");
        this.resize();
        window.addEventListener("resize", () => this.resize());
    }

    resize() {
        this.canvas.width = this.canvas.parentElement.clientWidth;
        this.canvas.height = this.canvas.parentElement.clientHeight;
        this.render();
    }

    generateMap() {
        const biomes = ["GRASSLAND", "PLAINS", "DESERT", "OCEAN", "MOUNTAIN", "FOREST"];
        this.grid = [];

        for (let r = 0; r < this.height; r++) {
            for (let q = 0; q < this.width; q++) {
                let rand = Math.random();
                let biome = "PLAINS";
                if (q === 0 || r === 0 || q === this.width - 1 || r === this.height - 1) {
                    biome = "OCEAN";
                } else if (rand < 0.15) {
                    biome = "OCEAN";
                } else if (rand < 0.35) {
                    biome = "GRASSLAND";
                } else if (rand < 0.55) {
                    biome = "FOREST";
                } else if (rand < 0.75) {
                    biome = "PLAINS";
                } else if (rand < 0.88) {
                    biome = "DESERT";
                } else {
                    biome = "MOUNTAIN";
                }

                this.grid.push({
                    q, r, biome,
                    owner: -1,
                    cityId: null,
                    explored: false,
                    visible: false
                });
            }
        }
        this.updateVision();
    }

    spawnInitialUnits() {
        this.units.push({
            id: 1, type: "SETTLER", owner: 0, q: 4, r: 4, hp: 50, maxHp: 50, moves: 2
        });
        this.units.push({
            id: 2, type: "WARRIOR", owner: 0, q: 5, r: 4, hp: 100, maxHp: 100, moves: 2
        });
        this.units.push({
            id: 3, type: "WARRIOR", owner: 1, q: 13, r: 9, hp: 100, maxHp: 100, moves: 2
        });
        this.updateVision();
    }

    updateVision() {
        // Reset visible
        this.grid.forEach(t => t.visible = !this.fowEnabled);

        if (!this.fowEnabled) return;

        // Player unit vision
        this.units.filter(u => u.owner === 0).forEach(u => {
            this.getTilesInRange(u.q, u.r, 2).forEach(t => {
                t.explored = true;
                t.visible = true;
            });
        });

        // Player city vision
        this.cities.filter(c => c.owner === 0).forEach(c => {
            this.getTilesInRange(c.q, c.r, 3).forEach(t => {
                t.explored = true;
                t.visible = true;
            });
        });
    }

    getTilesInRange(cq, cr, range) {
        return this.grid.filter(t => {
            let dist = (Math.abs(t.q - cq) + Math.abs(t.r - cr) + Math.abs((-t.q - t.r) - (-cq - cr))) / 2;
            return dist <= range;
        });
    }

    hexToPixel(q, r) {
        const x = this.hexRadius * (Math.sqrt(3) * q + Math.sqrt(3)/2 * r) + 100;
        const y = this.hexRadius * (3/2 * r) + 80;
        return { x, y };
    }

    render() {
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

        // Render Hex Grid
        this.grid.forEach(t => {
            const { x, y } = this.hexToPixel(t.q, t.r);
            this.drawHex(x, y, this.hexRadius, t);
        });

        // Render Borders
        this.cities.forEach(c => {
            this.getTilesInRange(c.q, c.r, c.borderRadius || 1).forEach(t => {
                const { x, y } = this.hexToPixel(t.q, t.r);
                this.drawBorder(x, y, this.hexRadius, c.owner === 0 ? "#3b82f6" : "#ef4444");
            });
        });

        // Render Cities
        this.cities.forEach(c => {
            const { x, y } = this.hexToPixel(c.q, c.r);
            this.drawCity(x, y, c);
        });

        // Render Units
        this.units.forEach(u => {
            const tile = this.grid.find(t => t.q === u.q && t.r === u.r);
            if (!this.fowEnabled || (tile && tile.visible)) {
                const { x, y } = this.hexToPixel(u.q, u.r);
                this.drawUnit(x, y, u);
            }
        });

        this.updateHUD();
    }

    drawHex(x, y, radius, tile) {
        this.ctx.beginPath();
        for (let i = 0; i < 6; i++) {
            const angle = (Math.PI / 180) * (60 * i + 30);
            const px = x + radius * Math.cos(angle);
            const py = y + radius * Math.sin(angle);
            if (i === 0) this.ctx.moveTo(px, py);
            else this.ctx.lineTo(px, py);
        }
        this.ctx.closePath();

        // Biome Color
        let color = "#374151";
        if (tile.visible || !this.fowEnabled) {
            switch(tile.biome) {
                case "GRASSLAND": color = "#10b981"; break;
                case "PLAINS": color = "#f59e0b"; break;
                case "DESERT": color = "#fcd34d"; break;
                case "FOREST": color = "#047857"; break;
                case "OCEAN": color = "#1d4ed8"; break;
                case "MOUNTAIN": color = "#6b7280"; break;
            }
        } else if (tile.explored) {
            color = "#1f2937";
        }

        this.ctx.fillStyle = color;
        this.ctx.fill();

        this.ctx.strokeStyle = "rgba(255, 255, 255, 0.08)";
        this.ctx.lineWidth = 1;
        this.ctx.stroke();

        // Highlight selection
        if (this.selectedTile && this.selectedTile.q === tile.q && this.selectedTile.r === tile.r) {
            this.ctx.strokeStyle = "#fbbf24";
            this.ctx.lineWidth = 3;
            this.ctx.stroke();
        }
    }

    drawBorder(x, y, radius, color) {
        this.ctx.beginPath();
        for (let i = 0; i < 6; i++) {
            const angle = (Math.PI / 180) * (60 * i + 30);
            const px = x + (radius - 2) * Math.cos(angle);
            const py = y + (radius - 2) * Math.sin(angle);
            if (i === 0) this.ctx.moveTo(px, py);
            else this.ctx.lineTo(px, py);
        }
        this.ctx.closePath();
        this.ctx.strokeStyle = color;
        this.ctx.lineWidth = 2;
        this.ctx.stroke();
    }

    drawCity(x, y, city) {
        this.ctx.font = "20px sans-serif";
        this.ctx.textAlign = "center";
        this.ctx.textBaseline = "middle";
        this.ctx.fillText("🏛️", x, y);
    }

    drawUnit(x, y, unit) {
        this.ctx.font = "18px sans-serif";
        this.ctx.textAlign = "center";
        this.ctx.textBaseline = "middle";
        let icon = unit.type === "SETTLER" ? "🚩" : "⚔️";
        this.ctx.fillText(icon, x, y - 4);

        // Player indicator ring
        this.ctx.beginPath();
        this.ctx.arc(x, y + 10, 6, 0, Math.PI * 2);
        this.ctx.fillStyle = unit.owner === 0 ? "#3b82f6" : "#ef4444";
        this.ctx.fill();
    }

    bindEvents() {
        this.canvas.addEventListener("click", (e) => {
            const rect = this.canvas.getBoundingClientRect();
            const mouseX = e.clientX - rect.left;
            const mouseY = e.clientY - rect.top;

            let closest = null;
            let minDist = Infinity;

            this.grid.forEach(t => {
                const { x, y } = this.hexToPixel(t.q, t.r);
                const d = Math.hypot(mouseX - x, mouseY - y);
                if (d < this.hexRadius && d < minDist) {
                    minDist = d;
                    closest = t;
                }
            });

            if (closest) {
                this.selectTile(closest);
            }
        });

        document.getElementById("btn-end-turn").addEventListener("click", () => this.endTurn());
        document.getElementById("btn-toggle-fow").addEventListener("click", () => {
            this.fowEnabled = !this.fowEnabled;
            this.updateVision();
            this.render();
            this.showToast(`Fog of War: ${this.fowEnabled ? "ENABLED" : "DISABLED"}`);
        });

        document.getElementById("btn-open-tech").addEventListener("click", () => {
            this.renderTechTree();
            document.getElementById("tech-modal").classList.remove("hidden");
        });

        document.getElementById("btn-close-tech").addEventListener("click", () => {
            document.getElementById("tech-modal").classList.add("hidden");
        });

        document.getElementById("btn-rts-skirmish").addEventListener("click", () => {
            document.getElementById("skirmish-modal").classList.remove("hidden");
        });

        document.getElementById("btn-close-skirmish").addEventListener("click", () => {
            document.getElementById("skirmish-modal").classList.add("hidden");
        });

        document.getElementById("btn-start-skirmish").addEventListener("click", () => {
            this.runSkirmishSimulation();
        });

        document.getElementById("btn-close-inspector").addEventListener("click", () => {
            document.getElementById("inspector-panel").classList.add("hidden");
        });
    }

    selectTile(tile) {
        this.selectedTile = tile;
        this.render();

        const panel = document.getElementById("inspector-panel");
        const title = document.getElementById("inspector-title");
        const details = document.getElementById("inspector-details");
        const actions = document.getElementById("inspector-actions");

        panel.classList.remove("hidden");
        title.innerText = `Tile (${tile.q}, ${tile.r})`;

        details.innerHTML = `
            <p><strong>Biome:</strong> ${tile.biome}</p>
            <p><strong>Owner:</strong> ${tile.owner === 0 ? "Sovereigns (Player)" : tile.owner === 1 ? "Iron Legion (AI)" : "Unclaimed"}</p>
        `;

        actions.innerHTML = "";

        // Check if unit present
        const unit = this.units.find(u => u.q === tile.q && u.r === tile.r && u.owner === 0);
        if (unit) {
            if (unit.type === "SETTLER") {
                const btnFound = document.createElement("button");
                btnFound.className = "btn-primary";
                btnFound.innerText = "FOUND CITY";
                btnFound.onclick = () => this.foundCity(unit, tile);
                actions.appendChild(btnFound);
            }
        }
    }

    foundCity(unit, tile) {
        this.cities.push({
            id: this.cities.length + 1,
            name: "Solaria",
            owner: 0,
            q: tile.q,
            r: tile.r,
            borderRadius: 1
        });

        // Remove settler
        this.units = this.units.filter(u => u.id !== unit.id);
        this.updateVision();
        this.render();
        this.showToast("🏰 City of Solaria Founded!");
        document.getElementById("inspector-panel").classList.add("hidden");
    }

    endTurn() {
        this.turn++;
        
        // Yields
        this.resources.gold += this.resources.goldYield;
        this.resources.science += this.resources.scienceYield;
        this.resources.culture += this.resources.cultureYield;

        // Science Progress
        if (this.activeResearch) {
            const tech = this.techs.find(t => t.id === this.activeResearch);
            if (tech && !tech.unlocked) {
                this.researchProgress += this.resources.scienceYield;
                if (this.researchProgress >= tech.cost) {
                    tech.unlocked = true;
                    this.showToast(`🧪 Technology Unlocked: ${tech.name}!`);
                    this.activeResearch = null;
                }
            }
        }

        // AI Strategic Turn
        this.runAITurn();

        this.updateVision();
        this.render();
        this.showToast(`Turn ${this.turn} Started`);
    }

    runAITurn() {
        // AI Unit Move
        const aiUnit = this.units.find(u => u.owner === 1);
        if (aiUnit) {
            aiUnit.q += (Math.random() > 0.5 ? 1 : -1);
            aiUnit.q = Math.max(1, Math.min(this.width - 2, aiUnit.q));
        }
    }

    updateHUD() {
        document.getElementById("gold-val").innerText = this.resources.gold;
        document.getElementById("science-val").innerText = this.resources.science;
        document.getElementById("culture-val").innerText = this.resources.culture;
        document.getElementById("turn-num").innerText = this.turn;
    }

    renderTechTree() {
        const grid = document.getElementById("tech-grid");
        grid.innerHTML = "";

        this.techs.forEach(t => {
            const card = document.createElement("div");
            card.className = `tech-card ${t.unlocked ? "unlocked" : ""} ${this.activeResearch === t.id ? "active" : ""}`;
            card.innerHTML = `
                <h4>${t.name}</h4>
                <p>Cost: ${t.cost} Science</p>
                <p>Status: ${t.unlocked ? "Unlocked" : this.activeResearch === t.id ? `Researching (${this.researchProgress}/${t.cost})` : "Available"}</p>
            `;

            if (!t.unlocked) {
                card.onclick = () => {
                    this.activeResearch = t.id;
                    this.researchProgress = 0;
                    this.renderTechTree();
                    this.showToast(`Active Research set to ${t.name}`);
                };
            }

            grid.appendChild(card);
        });
    }

    runSkirmishSimulation() {
        const log = document.getElementById("skirmish-log");
        log.innerHTML = "<p>⚡ Initiating Tactical RTS Engagement...</p>";

        let hpA = 100;
        let hpB = 100;

        let interval = setInterval(() => {
            let dmgA = Math.floor(Math.random() * 20) + 10;
            let dmgB = Math.floor(Math.random() * 18) + 8;

            hpB = Math.max(0, hpB - dmgA);
            hpA = Math.max(0, hpA - dmgB);

            log.innerHTML += `<p>⚔️ Sovereigns deals ${dmgA} dmg to Legion (HP: ${hpB}). Legion deals ${dmgB} dmg to Sovereigns (HP: ${hpA}).</p>`;
            log.scrollTop = log.scrollHeight;

            if (hpA <= 0 || hpB <= 0) {
                clearInterval(interval);
                let winner = hpA > 0 ? "VICTORY! Sovereigns defeated the Iron Legion!" : "DEFEAT! Iron Legion prevailed.";
                log.innerHTML += `<p style="color:#fbbf24; font-weight:bold; margin-top:8px;">🏆 ${winner}</p>`;
                log.scrollTop = log.scrollHeight;
            }
        }, 600);
    }

    showToast(msg) {
        const container = document.getElementById("toast-container");
        const toast = document.createElement("div");
        toast.className = "toast";
        toast.innerText = msg;
        container.appendChild(toast);
        setTimeout(() => toast.remove(), 3000);
    }
}

window.addEventListener("DOMContentLoaded", () => {
    window.gameEngine = new SovereignsEngine();
});
