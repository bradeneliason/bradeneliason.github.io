document.addEventListener("DOMContentLoaded", function () {
  'use strict';

  var content = document.querySelector(".post__content");
  if (!content) return;

  var LETTERS = "abcdefghijklmnopqrstuvwxyz";

  function shouldSkip(img) {
    return img.classList.contains("no-lightense") || img.closest("a");
  }

  function makeFigure(img, captionText) {
    var figure = document.createElement("figure");
    img.parentNode.insertBefore(figure, img);
    figure.appendChild(img);

    if (captionText) {
      var figcaption = document.createElement("figcaption");
      figcaption.textContent = captionText;
      figure.appendChild(figcaption);
    }
  }

  function captionFor(label, img) {
    var alt = img.getAttribute("alt") || "";
    return alt ? label + ": " + alt : label;
  }

  // Walk the post body in true document order so numbering reflects
  // top-to-bottom reading order regardless of how groups and standalone
  // images are interleaved.
  var walker = document.createTreeWalker(content, NodeFilter.SHOW_ELEMENT, {
    acceptNode: function (node) {
      if (node.tagName === "IMG") return NodeFilter.FILTER_ACCEPT;
      if (node.classList && node.classList.contains("fig-group")) {
        return NodeFilter.FILTER_ACCEPT;
      }
      return NodeFilter.FILTER_SKIP;
    }
  });

  var counter = 0;
  var handled = new Set();
  var node;

  while ((node = walker.nextNode())) {
    if (node.tagName === "IMG") {
      if (handled.has(node) || shouldSkip(node)) continue;
      counter += 1;
      makeFigure(node, captionFor("Fig. " + counter, node));
      continue;
    }

    // .fig-group: number its images together under one incremented
    // counter value, lettered in order. Mark them handled so the
    // walker's later visits to these same <img> nodes are no-ops.
    counter += 1;
    var images = node.querySelectorAll("img");

    images.forEach(function (img, index) {
      handled.add(img);
      if (shouldSkip(img)) return;
      var label = "Fig. " + counter + LETTERS.charAt(index % LETTERS.length);
      makeFigure(img, captionFor(label, img));
    });
  }
});
