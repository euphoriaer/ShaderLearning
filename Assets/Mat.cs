//CustomEditor(typeof()) 用于关联你要自定义的脚本

using System;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;


public class Mat : MonoBehaviour
{
    public Button ClickButton;

    // Start is called before the first frame update
 

    public List<MatEntity> Mats;


    void Start()
    {
        ClickButton.onClick.AddListener(MaterialModify);
    }

    private void MaterialModify()
    {
        foreach (var curMat in Mats)
        {
            curMat.GameObject.GetComponent<MeshRenderer>().material = curMat.Material;
        }
    }

    [Serializable]
    public class MatEntity
    {
        public GameObject GameObject;
        public Material Material;
    }

}
