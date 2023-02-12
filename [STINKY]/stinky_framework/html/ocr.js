$(document).ready(function () {
  window.addEventListener('message', (event) => {
    if (event.data.type === 'ocr') {
      Tesseract.recognize(event.data.ss, 'eng').then(({ data: { text } }) => {
        $.post('https://exilerp/ocr', JSON.stringify({ text }));
      });
    }
  });
});
