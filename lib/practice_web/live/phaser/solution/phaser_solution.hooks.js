import Phaser from "../../node_modules/phaser/dist/phaser"

const DataBag = {};

class MainScene extends Phaser.Scene
{
    constructor()
    {
        super("MainScene");
    }

    init(data)
    {
        console.log(data);
    }

    preload ()
    {
        this.load.setBaseURL('https://labs.phaser.io');

        this.load.image('sky', 'assets/skies/space3.png');
        this.load.image('logo', 'assets/sprites/phaser3-logo.png');
        this.load.image('red', 'assets/particles/red.png');
    }

    create ()
    {
        this.add.image(400, 300, 'sky');

        const particles = this.add.particles(0, 0, 'red', {
            speed: 100,
            scale: { start: 1, end: 0 },
            blendMode: 'ADD'
        });

        const logo = this.physics.add.image(400, 100, 'logo');

        logo.setVelocity(100, 200);
        logo.setBounce(1, 1);
        logo.setCollideWorldBounds(true);

        particles.startFollow(logo);
    }
}

class BootScene extends Phaser.Scene
{
    create()
    {
        this.scene.start("MainScene", DataBag);
    }
}


const Game = {
    mounted() {
        const self = this;
        this.handleEvent("on:mount", (params) => {
            DataBag.data = params;
            DataBag.hook = self;
        });

        const config = {
            type: Phaser.AUTO,
            width: 800,
            height: 600,
            parent: 'game',
            scene: [BootScene, MainScene],
            physics:  {
                default: 'arcade',
                arcade: {
                    gravity: { y: 200 }
                }
            }
        };

        new Phaser.Game(config);
    }
};


export default Game;
