using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class HairLightSecondManager : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        Shader.SetGlobalVector("_HairSecondLightDirection",this.transform.forward);
    }

    // Update is called once per frame
    void Update()
    {
        Shader.SetGlobalVector("_HairSecondLightDirection",this.transform.forward);
    }
}
