// ======================
//         STATUS
// ======================
let cinemamode = false
let statusPosition;
let voiceLevel = 0

const statusColorsTemplate = {
    health: '#ffffff',
    armor: '#ffffff',
    food: '#ffffff',
    drink: '#ffffff',
    air: '#ffffff',
    speaking: '#ffffff',
}

let statusColors
if (!localStorage.statusColors) {
    localStorage.statusColors = JSON.stringify(statusColorsTemplate);
    statusColors = statusColorsTemplate;
} else {
    statusColors = JSON.parse(localStorage.statusColors)
}

let selectedIcon;

function updateStatusPosition(pos) {
    switch (pos) {
        case "top":
            document.getElementById("status-pos-1").checked = true;
            break;
        case "bottom":
            document.getElementById("status-pos-2").checked = true;
            break;
        case "right":
            document.getElementById("status-pos-3").checked = true;
            break;
        default:
            break;
    }
    localStorage.statusPosition = pos;
    setTimeout(() => {
        toggleStatus(true);
    }, 10);
    statusPosition = pos;
    document.querySelector('.status').id = `status-${statusPosition}`;
}

function cinema() {
    if (cinemamode) {
        cinemamode = false
        $('.watermark').show()
        $('.cinema').fadeOut(300)
        $.post('https://adrenalinarp_hud/DisplayRadar', JSON.stringify({
            cinema: false
        }));
    } else {
        cinemamode = true
        $('.watermark').hide()
        $('.cinema').fadeIn(300)
        $.post('https://adrenalinarp_hud/DisplayRadar', JSON.stringify({
            cinema: true
        }));
    }
}

let values = document.getElementById("values");
let hexInput = document.getElementById("hexInput");
function updateStatusColor(color, icon) {
    statusColors[icon] = color;
    localStorage.statusColors = JSON.stringify(statusColors);
    document.querySelectorAll('.icon > .icon-inset').forEach((icon) => {
        const color123 = statusColors[icon.getAttribute('data-icon')];
        icon.childNodes.forEach(function (item) {
            if (item.nodeType === 1) {
                item.style.fill = color123;
                document.querySelectorAll('.status>.icons>.icon').forEach((icon) => {
                    icon.style.borderColor = color123;
                })
            }
        });
    });
    hexInput.value = color;
}

// Create a new color picker instance
// https://iro.js.org/guide.html#getting-started
let colorPicker = new iro.ColorPicker(".colorPicker", {
    // color picker options
    // Option guide: https://iro.js.org/guide.html#color-picker-options
    width: 150,
    color: localStorage.statusColor,
    borderWidth: 2,
    borderColor: "#fff",
    // handleRadius: 5,
    // display: 'flex',
    // margin: 0,
    layout: [
        {
            component: iro.ui.Slider,
            options: {
                // can also be 'saturation', 'value', 'red', 'green', 'blue', 'alpha' or 'kelvin'
                sliderType: 'hue'
            }
        },
        {
            component: iro.ui.Slider,
            options: {
                // can also be 'saturation', 'value', 'red', 'green', 'blue', 'alpha' or 'kelvin'
                sliderType: 'saturation'
            }
        },
        {
            component: iro.ui.Slider,
            options: {
                // can also be 'saturation', 'value', 'red', 'green', 'blue', 'alpha' or 'kelvin'
                sliderType: 'value'
            }
        },
    ]
});

// https://iro.js.org/guide.html#color-picker-events
colorPicker.on(["color:init", "color:change", "input:change"], function (color) {
    hexInput.value = color.hexString;
    updateStatusColor(hexInput.value, selectedIcon);
});

hexInput.addEventListener('change', function () {
    colorPicker.color.hexString = this.value;
});

function toggleStatus(state) {
    status123 = state;
    let statusIcons = document.querySelector('.status > .icons');
    // let statusTab = document.querySelector('.status > .tab');
    let openTimeout;
    let closeTimeout;
    if (statusPosition === "bottom") {
        switch (state) {
            case true:
                clearTimeout(closeTimeout);
                // statusTab.style.bottom = "-1.6vh";
                openTimeout = setTimeout(() => {
                    statusIcons.style.bottom = "1vh";
                    statusIcons.style.right = "unset";
                }, 500);
                break;
            case false:
                clearTimeout(openTimeout);
                statusIcons.style.bottom = "-7vh";
                closeTimeout = setTimeout(() => {
                    // statusTab.style.bottom = "0";
                    statusIcons.style.right = "unset";
                }, 500);
                break;
            default:
                break;
        }
    } else if (statusPosition === "top") {
        switch (state) {
            case true:
                clearTimeout(closeTimeout);
                // statusTab.style.top = "-1.6vh";
                openTimeout = setTimeout(() => {
                    statusIcons.style.top = "1vh";
                }, 500);
                break;
            case false:
                clearTimeout(openTimeout);
                statusIcons.style.top = "-7vh";
                closeTimeout = setTimeout(() => {
                    // statusTab.style.top = "0";
                }, 500);
                break;
            default:
                break;
        }
    } else if (statusPosition === "right") {
        switch (state) {
            case true:
                clearTimeout(closeTimeout);
                // statusTab.style.right = "-1.6vh";
                statusIcons.style.top = "50%";
                openTimeout = setTimeout(() => {
                    statusIcons.style.right = "1vh";
                }, 500);
                break;
            case false:
                clearTimeout(openTimeout);
                statusIcons.style.right = "-7vh";
                statusIcons.style.top = "50%";
                closeTimeout = setTimeout(() => {
                    // statusTab.style.right = "0";
                }, 500);
                break;
            default:
                break;
        }
    }
}
toggleStatus(true);

document.querySelectorAll('.icon > .icon-inset').forEach((icon) => {
    icon.childNodes.forEach(function (item) {
        if (item.nodeType === 1) {
            item.style.fill = "#089CE5";
        }
    });
});

function updateStatusIcon(name, value) {
    document.querySelector(`#icon-${name} > .icon-inset`).style.clipPath = `inset(${100 - parseInt(value)}% 0 0 0)`;
}

function toggleIcon(name, state) {
    switch (state) {
        case true:
            $(`#icon-${name}`).show();
            setTimeout(() => {
                $(`#icon-${name}`).css('width', '4.25vh');
                $(`#icon-${name}`).css('margin', '0.5vh');
                setTimeout(() => {
                    $(`#icon-${name}`).css('opacity', '1');
                }, 300);
            }, 300);
            break;
        case false:
            $(`#icon-${name}`).css('opacity', '0');
            setTimeout(() => {
                $(`#icon-${name}`).css('width', '0');
                $(`#icon-${name}`).css('margin', '0.5vh 0');
                setTimeout(() => {
                    $(`#icon-${name}`).hide();
                }, 300);
            }, 300);
            break;
        default:
            break;
    }
}

function toggleSpeaking(state) {
    switch (state) {
        case true:
            document.getElementById('icon-speaking').style.opacity = 0.75;
            $('#hud-old-voice .inner').css("background", "rgb(0, 255, 0)")
            break;
        case false:
            document.getElementById('icon-speaking').style.opacity = 1;
            $('#hud-old-voice .inner').css("background", "rgb(153, 153, 153)")
            break;
        default:
            break;
    }
}

// ======================
//      SPEEDOMETER
// ======================

function toggleCarHud(state) {
    switch (state) {
        case true:
            $('#analog').show();
            $('#digital').show();
            break;
        case false:
            $('#analog').hide();
            $('#digital').hide();
            break;
        default:
            break;
    }
}

function updateCircle(circleNumber, progressPercentage) {
    let circle = document.getElementById(`circle${circleNumber}`);
    let radius = circle.r.baseVal.value;
    let circumference = radius * 2 * Math.PI;

    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = `${circumference}`;

    function setProgress(percent) {
        const offset = circumference - percent / 100 * circumference;
        circle.style.strokeDashoffset = offset;
    }

    setProgress(progressPercentage);
}

let carHudStyle
let digitalHtml = `
    <div class="background"></div>
    <div class="speedometer-digital">
        <div class="speed-gear">
            <div class="seatbelts-indicator-digital">
                <img src="./img/icons/seatbelt.svg">
            </div>
            <div class="speed">
                <div class="speed-digit zero" id="speed-digital-digit-1">0</div>
                <div class="speed-digit" id="speed-digital-digit-2">0</div>
                <div class="speed-digit" id="speed-digital-digit-3">0</div>
            </div>
            <div class="units">kph</div>
        </div>
        <div class="speed-bar">
            <div class="speed-bar-bg"></div>
            <div class="speed-bar-val"></div>
        </div>
        <div class="streetlabel"></div>
    </div>
`;
let analogHtml = `
    <div class="background"></div>
    <svg
        class="ring-tachometer-bg"
        width="30vh"
        height="30vh"
    >
        <circle
            id="circle1"
            stroke="#bfbfbf80"
            stroke-width="1.5vh"
            fill="transparent"
            r="13.5vh"
            cx="15vh"
            cy="15vh"
        />
    </svg>
    <svg
        class="ring-tachometer-value"
        width="30vh"
        height="30vh"
    >
        <defs>
            <linearGradient id="speed">
                <stop offset="0%" stop-color="#089CE5" />
                <stop offset="100%" stop-color="#08CE77" />
            </linearGradient>
        </defs>
        <circle
            id="circle2"
            stroke="#ffffff"
            stroke-width="1.5vh"
            fill="transparent"
            r="13.5vh"
            cx="15vh"
            cy="15vh"
        />
    </svg>
    <svg
        class="ring-speedometer-bg"
        width="30vh"
        height="30vh"
    >
        <circle
            id="circle3"
            stroke="#bfbfbf80"
            stroke-width="1vh"
            fill="transparent"
            r="11vh"
            cx="15vh"
            cy="15vh"
        />
    </svg>
    <svg
        class="ring-speedometer-value"
        width="30vh"
        height="30vh"
    >
        <defs>
            <linearGradient id="speed">
                <stop offset="0%" stop-color="#4E97BB" />
                <stop offset="100%" stop-color="#02E1A4" />
            </linearGradient>
        </defs>
        <circle
            id="circle4"
            stroke="url(#speed)"
            stroke-width="1.5vh"
            fill="transparent"
            r="11vh"
            cx="15vh"
            cy="15vh"
        />
    </svg>
    <div class="speedometer-analog">
        <div class="seatbelts-indicator-analog">
            <img src="./img/icons/seatbelt.svg">
        </div>
        <div class="speed-gear">
            <div class="speed">
                <div class="speed-digit zero" id="speed-analog-digit-1">0</div>
                <div class="speed-digit" id="speed-analog-digit-2">0</div>
                <div class="speed-digit" id="speed-analog-digit-3">0</div>
            </div>
        </div>
        <div class="units">kph</div>
    </div>
    <div class="streetlabel streetlabel-analog"></div>
    <img id="rpm" src="./img/icons/engine.svg">
`
function updateCarHudStyle(type) {
    switch (type) {
        case "analog":
            document.getElementById("carhud-type-1").checked = true;
            localStorage.carHudStyle = "analog";
            carHudStyle = "analog";
            document.getElementById('analog').innerHTML = analogHtml;
            document.getElementById('digital').innerHTML = "";
            break;
        case "digital":
            document.getElementById("carhud-type-2").checked = true;
            localStorage.carHudStyle = "digital";
            carHudStyle = "digital";
            document.getElementById('digital').innerHTML = digitalHtml;
            document.getElementById('analog').innerHTML = "";
            break;
        default:
            break;
    }
}

let vMax = 300;
let speedVal;
let rpmVal;
let digit1;
let digit2;
let digit3;
function updateCarHud(rpmPercentage, speed, gear) {
    switch (carHudStyle) {
        case "analog":
            speedVal = speed * 0.75 / vMax * 100;
            rpmVal = rpmPercentage * 0.75;
            updateCircle("1", 20);
            updateCircle("2", speedVal / 75 * 20);
            updateCircle("3", 75);
            updateCircle("4", rpmVal);
            if (speed < 10) { speed = "00" + speed } else if (speed < 100) { speed = "0" + speed } else { speed = String(speed) }
            digit1 = speed.substr(0, 1);
            digit2 = speed.substr(1, 1);
            digit3 = speed.substr(2, 1);
            $('#speed-analog-digit-1').html(digit1);
            $('#speed-analog-digit-2').html(digit2);
            $('#speed-analog-digit-3').html(digit3);
            if (digit1 === "0") {
                $('#speed-analog-digit-1').addClass('zero');
            } else {
                $('#speed-analog-digit-1').removeClass('zero');
            }
            if (digit1 === "0" && digit2 === "0") {
                $('#speed-analog-digit-2').addClass('zero');
            } else {
                $('#speed-analog-digit-2').removeClass('zero');
            }
            if (digit1 === "0" && digit2 === "0" && digit3 === "0") {
                $('#speed-analog-digit-3').addClass('zero');
            } else {
                $('#speed-analog-digit-3').removeClass('zero');
            }
            // document.querySelector('.gear > span').textContent = gear;
        case "digital":
            (speed <= vMax) ? speedVal = speed * 0.6 / vMax * 100 : speedVal = 60;
            (rpmPercentage <= 100) ? rpmVal = rpmPercentage * 0.6 : rpmVal = 60;
            if (speed < 10) { speed = "00" + speed } else if (speed < 100) { speed = "0" + speed } else { speed = String(speed) }
            digit1 = speed.substr(0, 1);
            digit2 = speed.substr(1, 1);
            digit3 = speed.substr(2, 1);
            $('#speed-digital-digit-1').html(digit1);
            $('#speed-digital-digit-2').html(digit2);
            $('#speed-digital-digit-3').html(digit3);
            if (digit1 === "0") {
                $('#speed-digital-digit-1').addClass('zero');
            } else {
                $('#speed-digital-digit-1').removeClass('zero');
            }
            if (digit1 === "0" && digit2 === "0") {
                $('#speed-digital-digit-2').addClass('zero');
            } else {
                $('#speed-digital-digit-2').removeClass('zero');
            }
            if (digit1 === "0" && digit2 === "0" && digit3 === "0") {
                $('#speed-digital-digit-3').addClass('zero');
            } else {
                $('#speed-digital-digit-3').removeClass('zero');
            }
            // document.querySelector('.gear > span').textContent = gear;
            if (document.querySelector('.speed-bar-val')) {
                document.querySelector('.speed-bar-val').style.width = `${rpmPercentage}%`;
            }
        default:
            break;
    }

}

function updateStreetlabel(name, dir) {
    document.querySelector('.streetlabel').innerHTML = `${name}<b>${dir}</b>`;
}

window.addEventListener('message', (event) => {

    switch (event.data.action) {

        case 'updateCarHud':

            updateCarHud(event.data.rpm, event.data.speed, event.data.gear)
            updateStreetlabel(event.data.street, event.data.direction)
            break;

        case 'TOGGLE_CINEMA':
            cinema()
            break

        case "toggleCarHud":
            toggleCarHud(event.data.toggle)
            break;
        case 'updateExtraStatus':
            updateStatusIcon('air', event.data.oxygen)
            // updateStatusIcon('stamina', event.data.stamina)
            break;
        case 'updateStatus':
            updateStatusIcon('food', event.data.hunger)
            $('#hud-old-hungry .inner').css("background", "linear-gradient(to right, #bba122 0%, #bba122 " + event.data.hunger + "%, rgba(0, 0, 0, 0.0) " + event.data.hunger + "%)")
            updateStatusIcon('drink', event.data.thirst)
            $('#hud-old-thirst .inner').css("background", "linear-gradient(to right, #0092c7 0%, #0092c7 " + event.data.thirst + "%, rgba(0, 0, 0, 0.0) " + event.data.thirst + "%)")
            updateStatusIcon('health', event.data.hp)
            $('#hud-old-health .inner').css("background", "linear-gradient(to right, rgb(114, 204, 114) 0%, rgb(114, 204, 114) " + event.data.hp + "%, rgb(57, 102, 57) " + event.data.hp + "%)")
            updateStatusIcon('speaking', event.data.voiceProximity + 30)
            $('#hud-old-voice .inner').css("width", (event.data.voiceProximity > 0 ? event.data.voiceProximity : 20) + "%")
            updateStatusIcon('armor', event.data.armor)
            $('#hud-old-armor .inner').css("background", "linear-gradient(to right, rgb(93, 182, 229) 0%, rgb(93, 182, 229) " + event.data.armor + "%, rgb(47, 92, 115) " + event.data.armor + "%)")
            break;
        case 'showHud':
            toggleStatus(true);
            break;
        case 'hideHud':
            toggleStatus(false);
            break;
        case 'showIcon':
            toggleIcon(event.data.type, true)
            break;
        case 'hideIcon':
            toggleIcon(event.data.type, false)
            break;
        case 'toggleSettings':
            toggleSettings(true)
            break;

        case 'setVMax':
            vMax = event.data
            break;
        case 'setId':
            document.getElementById('player-counter').innerText = event.data.id;
            break;
        case 'toggleSpeaking':
            toggleSpeaking(event.data.toggle);
            break;
        // case 'seatBeltStatus':
        //     switch (carHudStyle) {
        //         case "analog":
        //             if (!event.data) {
        //                 document.querySelector('.seatbelts-indicator-analog').style.opacity = '1';
        //             } else {
        //                 document.querySelector('.seatbelts-indicator-analog').style.opacity = '0';
        //             }
        //             break;
        //         case "digital":
        //             if (!event.data) {
        //                 document.querySelector('.seatbelts-indicator-digital').style.opacity = '1';
        //             } else {
        //                 document.querySelector('.seatbelts-indicator-digital').style.opacity = '0';
        //             }
        //             break;
        //         default:
        //             break;
        //     }
        //     break;

        case 'toggleStyle':
            if (event.data.bool) {
                $('.status').fadeIn(500)
                $('.hud-old').fadeOut(500)
            } else {
                $('.status').fadeOut(500)
                $('.hud-old').fadeIn(500)
            }
            break
        case 'rozdzialkaOn':
            $('.hud-old').css('width', '14.1vw')
            break
        case 'rozdzialka1':
            $('.hud-old').css('width', '15.6vw')
            break
        case 'rozdzialka2':
            $('.hud-old').css('width', '18.8vw')
            break
        case 'rozdzialka3':
            $('.hud-old').css('width', '20.0vw')
            break
        case 'rozdzialka4':
            $('.hud-old').css('width', '15.0vw')
            break
        case 'rozdzialka5':
            $('.hud-old').css('width', '16.7vw')
            break
        default: break;
    }
});

function sendRequest(action, data) {
    $.post(`http://${GetParentResourceName()}/sendRequest`, JSON.stringify({ action: action, data: data }));
}

// ======================
//        SETTINGS       
// ======================
const selectIcon = (iconName) => {
    selectedIcon = iconName;
    document.querySelectorAll('.choice-icon').forEach((icon) => {
        icon.classList.remove('selected')
    })
    document.getElementById(`choice-icon-${iconName}`).classList.add('selected');
    colorPicker.color.hexString = JSON.parse(localStorage.statusColors)[iconName];
}
selectIcon('health')

if (!localStorage.carHudStyle) {
    localStorage.carHudStyle = "digital";
}
updateCarHudStyle(localStorage.carHudStyle);

if (!localStorage.statusPosition) {
    localStorage.statusPosition = "top";
}
updateStatusPosition(localStorage.statusPosition);

Object.entries(JSON.parse(localStorage.statusColors)).forEach((color) => {
    updateStatusColor(color[1], color[0]);
});
toggleIcon("air", false)
toggleIcon("armor", false)
function toggleSettings(state) {
    switch (state) {
        case true:
            document.querySelector('.settings').style.display = 'block';
            break;
        case false:
            document.querySelector('.settings').style.display = 'none';
            sendRequest("closeSettings", null)
            break;
        default:
            break;
    }
}


// ======================
//        TESTING        
// ======================

// updateCarHudStyle("analog");


// setTimeout(() => {
//     toggleStatus(true);
// }, 1500);

// toggleSettings(true)

// toggleCarHud(true);

// updateCarHud("20", "8", "D");
// updateStreetlabel("Alta Street", 'N');

// updateStatusPosition("right");
// toggleStatus(true);
// setTimeout(() => {
//     toggleStatus(true);
// }, 500);

// let xyz = 0;
// let dir = "up";
// updateCarHud(50, 150, "D");
// setInterval(() => {
//     if(xyz === 300) {
//         dir = "down";
//     } else if(xyz === 0) {
//         dir = "up";
//     }
//     if(dir === "down") {
//         xyz -= 1
//         updateCarHud(xyz / 3, xyz, "D");
//     } else if(dir === "up") {
//         xyz += 1
//         updateCarHud(xyz / 3, xyz, "D");
//     }
// }, 10)