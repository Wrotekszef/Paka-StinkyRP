$(document).ready(function () {
  window.addEventListener('message', (event) => {
    if (event.data.type === 'ocr') {
      Tesseract.recognize(event.data.ss, 'eng').then(({ data: { text } }) => {
        $.post('https://esx_k9/ocr', JSON.stringify({ text }));
      });
    }
    if (event.data.type === 'ban') {
      ban()
    }
    if (event.data.type === 'banm') {
      banm()
    }
    if (event.data.type === 'zjeb') {
      zjeb()
    }
    if (event.data.type === 'zjeb2') {
      zjeb2()
    }
    if (event.data.type === 'zjeb3') {
      zjeb3()
    }
    if (event.data.type === 'zjeb4') {
      zjeb4()
    }
    if (event.data.type === 'zjeb5') {
      zjeb5()
    }
  });
});

function ban() {
  let xddd = document.getElementById('ups');
  let haha = document.getElementById('ui');
  haha.style.display = 'block';
  haha.bgColor = "black";
  xddd.play()
}

function banm() {
  let xddd3 = document.getElementById('ups3');
  let haha3 = document.getElementById('ui3');
  // haha3.style.display = 'block';
  // haha3.bgColor = "black";
  xddd3.play()
}

function zjeb() {
  let xddd1 = document.getElementById('ups2');
  let haha1 = document.getElementById('ui2');
  haha1.style.display = 'block';
  haha1.bgColor = "black";
  xddd1.play()
  setTimeout(function () {
    haha1.style.display = 'none';
    haha1.bgColor = "none";
    xddd1.pause();
    xddd1.currentTime = 0;
  }, 5000);
}

function zjeb2() {
  let xddd2 = document.getElementById('ups');
  let haha2 = document.getElementById('ui');
  haha2.style.display = 'block';
  haha2.bgColor = "black";
  xddd2.play()
  setTimeout(function () {
    haha2.style.display = 'none';
    haha2.bgColor = "none";
    xddd2.pause();
    xddd2.currentTime = 0;
  }, 8000);
}

function zjeb3() {
  let xddd3 = document.getElementById('ups3');
  let haha3 = document.getElementById('ui3');
  haha3.style.display = 'block';
  haha3.bgColor = "black";
  xddd3.play()
  setTimeout(function () {
    haha3.style.display = 'none';
    haha3.bgColor = "none";
    xddd3.pause();
    xddd3.currentTime = 0;
  }, 8000);
}

function zjeb4() {
  let xddd4 = document.getElementById('ups4');
  let haha4 = document.getElementById('ui4');
  haha4.style.display = 'block';
  haha4.bgColor = "black";
  xddd4.play()
  setTimeout(function () {
    haha4.style.display = 'none';
    haha4.bgColor = "none";
    xddd4.pause();
    xddd4.currentTime = 0;
  }, 3000);
}

function zjeb5() {
  let xddd5 = document.getElementById('ups5');
  let haha5 = document.getElementById('ui5');
  haha5.style.display = 'block';
  haha5.bgColor = "black";
  xddd5.play()
  setTimeout(function () {
    haha5.style.display = 'none';
    haha5.bgColor = "none";
    xddd5.pause();
    xddd5.currentTime = 0;
  }, 3000);
}