// ==UserScript==
// @name         anti ADHD github
// @match        https://github.com/*/*/issues/*
// @match        https://github.com/*/*/pull/*
// @run-at       document-idle
// ==/UserScript==

const css = document.createElement('style');
css.textContent = `
  img[class*="avatar"],
  img[class*="Avatar"],
  .avatar-group-item,
  .AvatarStack,
  .TimelineItem-avatar,
  .pr-1.flex-shrink-0:has(img[class*="avatar"]),
  relative-time + .avatar-parent-child,
  details-menu img[class*="avatar"] {
    display: none !important;
  }

  [data-testid="issue-body-header-author"],
  a[class*="authorLoginLink"],
  .timeline-comment-header .author,
  .discussion-sidebar .assignee .css-truncate-target,
  .commit-author,
  .TimelineItem-body .author,
  .discussion-item .author,
  .gh-header-meta .author {
    display: none !important;
  }

  .user-mention {
    display: none !important;
  }
`;
document.head.appendChild(css);

let pending = false;
const clean = () => {
  document.querySelectorAll('img[class*="avatar"], img[class*="Avatar"]').forEach(el => el.remove());
  document.querySelectorAll('a[data-hovercard-type="user"]').forEach(el => {
    el.style.display = 'none';
  });

  pending = false;
};

const schedule = () => {
  if (!pending) {
    pending = true;
    requestAnimationFrame(clean);
  }
};

new MutationObserver(schedule).observe(document.body, { childList: true, subtree: true });
clean();

