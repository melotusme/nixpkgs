{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson
, ninja, vala, desktop-file-utils, libxml2, gtk3, granite
, python3, libgee, clutter-gtk, json-glib, libgda, libgpod
, libnotify, libpeas, libsoup, zeitgeist, gst_all_1, taglib
, libdbusmenu, libsignon-glib, libaccounts-glib
, elementary-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "music";
  version = "5.0.3";

  name = "elementary-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0qbny4484kr7lihg54rbhfwah9k43iivk3rivfvn7i5w66vn5spl";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "elementary-${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = with gst_all_1; [
    clutter-gtk
    elementary-icon-theme
    granite
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
    gtk3
    json-glib
    libaccounts-glib
    libdbusmenu
    libgda
    libgee
    libgpod
    libsignon-glib
    libnotify
    libpeas
    libsoup
    taglib
    zeitgeist
  ];

  mesonFlags = [
    "-Dplugins=lastfm,audioplayer,cdrom,ipod"
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Music player and library designed for elementary OS";
    homepage = https://github.com/elementary/music;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
