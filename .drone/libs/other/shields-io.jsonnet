local base = {
    BASEURL:: "https://img.shields.io/badge/",
    new(label):: self + self.withColor("lightgrey").withLabel(label),
    withLabel(label):: self + {label: label},
    withText(text):: self + {text: text},
    withColor(color):: self + {color: color},
    render():: self.BASEURL + self.label + "-" + self.text + "-" + self.color
};


base