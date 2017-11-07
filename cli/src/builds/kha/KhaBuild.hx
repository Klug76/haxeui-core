package builds.kha;

import builds.Build;
import sys.io.File;

class KhaBuild extends Build {
    public function new() {
        super();
    }
    
    public override function execute(params:Params) {
        super.execute(params);
        
        Sys.setCwd(params.target);
        
        var target = "html5";
        if (Util.mapContains("windows", params.additional)) {
            target = "windows";
        }

        var hxmlFile = null;
        switch (target) {
            case "html5":
                hxmlFile = "kha-html5.hxml";
            case "windows":
                hxmlFile = "kha-windows.hxml";
            case _:
                throw "Unknown target!";
        }
        
        var p = new ProcessHelper();
        p.run('${params.target}/Kha/Tools/haxe/haxe', [hxmlFile]);
        
        if (target == "windows") {
            var content = 'call "%VS140COMNTOOLS%\\vsvars32.bat"\n';
            content += 'msbuild ${params.target}/Build/kha/windows-build/Main.vcxproj /m /p:Configuration=Release,Platform=Win32\n';
            File.saveContent('${params.target}/Build/kha/windows-build/release.bat', content);
            
            //p.run('"C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\Common7\\Tools\\vsvars32.bat"', []);
//            p.run('"%VS140COMNTOOLS%\\vsvars32.bat"', []);
            //p.run("msbuild", ['${params.target}/Build/kha/windows-build/Main.vcxproj', '/m', '/p:Configuration=Release,Platform=Win32']);
            p.run('${params.target}/Build/kha/windows-build/release.bat', []);
        }
        
        Sys.setCwd(params.cwd);
    }
}